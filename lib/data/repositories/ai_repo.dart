import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groq/groq.dart';
import 'package:http/io_client.dart';
import 'package:flutter_application_1/domain/entities/ai.dart';
import 'package:flutter_application_1/domain/repositories/ai_repo.dart';

// Implementation using the official `groq` client with a clear model, key
// validation, and request timeouts so UI does not hang.

const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
const Duration _requestTimeout = Duration(seconds: 20);
const String _modelName = 'llama-3-8b-instruct';

class GroqAIRepositoryImpl implements AiRepository {
  final Groq _groq;
  final String _apiKey;

  GroqAIRepositoryImpl({String? apiKey})
      : _apiKey = apiKey?.trim().isNotEmpty == true
            ? apiKey!.trim()
            : const String.fromEnvironment('groqApiKey'),
        _groq = Groq(
          apiKey: (apiKey?.trim().isNotEmpty == true
              ? apiKey!.trim()
              : const String.fromEnvironment('groqApiKey')),
          configuration: Configuration(
            model: _modelName,
            temperature: 0.7,
            seed: 10,
          ),
        ) {
    if (_apiKey.trim().isEmpty) {
      throw Exception(
        'Groq API key is missing. Provide it via .env GROQ_API_KEY or --dart-define=groqApiKey=YOUR_KEY',
      );
    }
    // Start a chat session and set friendly default instructions.
    _groq.startChat();
    _groq.setCustomInstructionsWith(
      'You are a helpful note assistant who guides users with their notes. Respond concisely and in bullet points when asked to summarize.',
    );
  }

  bool get _allowInsecure {
    // Enabled only in debug mode and when explicitly requested via env or dart-define
    final envFlag = dotenv.env['GROQ_ALLOW_INSECURE'];
    final defineFlag = const bool.fromEnvironment('GROQ_ALLOW_INSECURE', defaultValue: false);
    return kDebugMode && (envFlag == 'true' || defineFlag == true);
  }

  Future<String> _sendInsecurePrompt(String prompt) async {
    final inner = HttpClient();
    inner.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final client = IOClient(inner);
    try {
      final resp = await client
          .post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_apiKey}',
        },
        body: jsonEncode(
          {
            'model': _modelName,
            'messages': [
              {'role': 'system', 'content': 'You are a helpful note assistant who guides users with their notes.'},
              {'role': 'user', 'content': prompt}
            ]
          },
        ),
      )
          .timeout(_requestTimeout);

      if (resp.statusCode != 200) {
        throw Exception('Groq API error: ${resp.statusCode} ${resp.body}');
      }
      final data = jsonDecode(resp.body);
      final text = data['choices']?[0]?['message']?['content'] ?? '';
      return text;
    } finally {
      client.close();
    }
  }

  @override
  Future<AIResponse> summarize(String note) async {
    final prompt = 'Summarize this note in bullet points:\n$note';
    try {
      if (_allowInsecure) {
        final text = await _sendInsecurePrompt(prompt)
            .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq summarize request timed out'));
        return AIResponse(text);
      }
      final GroqResponse resp = await _groq
          .sendMessage(prompt)
          .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq summarize request timed out'));
      final text = resp.choices.isNotEmpty ? resp.choices.first.message.content : '';
      return AIResponse(text);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CERTIFICATE_VERIFY_FAILED') || msg.contains('HandshakeException')) {
        throw Exception('TLS verification failed when contacting Groq API. Check device/emulator time, network/proxy, or trust the proxy CA. Original: $msg');
      }
      rethrow;
    }
  }

  @override
  Future<AIResponse> rewrite(String note, String instruction) async {
    // Provide the instruction followed by the note.
    _groq.setCustomInstructionsWith('Rewrite using the following instruction: $instruction');
    try {
      if (_allowInsecure) {
        final text = await _sendInsecurePrompt('Rewrite: $instruction\n\n$note')
            .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq rewrite request timed out'));
        return AIResponse(text);
      }
      final GroqResponse resp = await _groq
          .sendMessage('Here is the note to rewrite:\n$note')
          .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq rewrite request timed out'));
      final text = resp.choices.isNotEmpty ? resp.choices.first.message.content : '';
      return AIResponse(text);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CERTIFICATE_VERIFY_FAILED') || msg.contains('HandshakeException')) {
        throw Exception('TLS verification failed when contacting Groq API. Check device/emulator time, network/proxy, or trust the proxy CA. Original: $msg');
      }
      rethrow;
    }
  }

  @override
  Future<AIResponse> chat(String note, String question) async {
    final prompt = 'NOTE:\n$note\n\nQUESTION:\n$question';
    try {
      if (_allowInsecure) {
        final text = await _sendInsecurePrompt(prompt)
            .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq chat request timed out'));
        return AIResponse(text);
      }
      final GroqResponse resp = await _groq
          .sendMessage(prompt)
          .timeout(_requestTimeout, onTimeout: () => throw TimeoutException('Groq chat request timed out'));
      final text = resp.choices.isNotEmpty ? resp.choices.first.message.content : '';
      return AIResponse(text);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('CERTIFICATE_VERIFY_FAILED') || msg.contains('HandshakeException')) {
        throw Exception('TLS verification failed when contacting Groq API. Check device/emulator time, network/proxy, or trust the proxy CA. Original: $msg');
      }
      rethrow;
    }
  }
}
