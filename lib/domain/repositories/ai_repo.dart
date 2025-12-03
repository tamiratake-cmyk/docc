import 'package:flutter_application_1/domain/entities/ai.dart';

abstract class AiRepository {
  Future<AIResponse> chat(String note, String question);
  Future<AIResponse> summarize(String noteText);
  // Future<AIResponse> generateTags(String noteText);
  Future<AIResponse> rewrite(String noteText, String instruction);
}