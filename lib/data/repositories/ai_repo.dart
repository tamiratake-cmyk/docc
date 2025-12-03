import 'dart:convert';
import 'package:flutter_application_1/domain/entities/ai.dart';
import 'package:flutter_application_1/domain/repositories/ai_repo.dart';
import 'package:http/http.dart' as http;


class GroqAIRepositoryImpl implements AiRepository {
  final String apiKey;

  GroqAIRepositoryImpl(this.apiKey);

  static const String baseUrl =
      "https://api.groq.com/openai/v1/chat/completions";

  Future<AIResponse> _sendPrompt(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "llama3-8b-8192",
        "messages": [
          {"role": "system", "content": "You are a helpful note assistant who guides users with their notes."},
          {"role": "user", "content": prompt}
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Groq API error: ${response.body}");
    }

    final data = jsonDecode(response.body);
    final text =
        data["choices"][0]["message"]["content"] ?? "No response received.";

    return AIResponse(text);
  }

  @override
  Future<AIResponse> summarize(String note) {
    final prompt = "Summarize this note in bullet points:\n$note";
    return _sendPrompt(prompt);
  }

  @override
  Future<AIResponse> rewrite(String note, String instruction) {
    final prompt = "$instruction.\nHere is the note:\n$note";
    return _sendPrompt(prompt);
  }

  @override
  Future<AIResponse> chat(String note, String question) {
    final prompt = """
NOTE:
$note

QUESTION:
$question
""";
    return _sendPrompt(prompt);
  }
}
