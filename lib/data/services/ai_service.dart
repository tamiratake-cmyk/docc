// class AIService {
//   final OpenAI _openAI;

//   AIService(this._openAI);

//   Future<String> summarize(String text) async {
//     final response = await _openAI.chat([
//       {"role": "system", "content": "You summarize notes concisely."},
//       {"role": "user", "content": "Summarize this: $text"}
//     ]);

//     return response.text;
//   }

//   Future<List<String>> generateTags(String text) async {
//     final response = await _openAI.chat([
//       {"role": "system", "content": "Return only words as tags, no explanation."},
//       {"role": "user", "content": "Create 3–7 tags for: $text"}
//     ]);

//     return response.text.split(",").map((e) => e.trim()).toList();
//   }

//   Future<String> explain(String text) async {
//     final response = await _openAI.chat([
//       {"role": "system", "content": "You explain writing like a teacher."},
//       {"role": "user", "content": "Explain this: $text"}
//     ]);

//     return response.text;
//   }
  
//   Future<String> askQuestion(String note, String question) async {
//     final response = await _openAI.chat([
//       {"role": "system", "content": "You are a helpful assistant."},
//       {"role": "user", "content": "Note: $note \n\nUser question: $question"}
//     ]);

//     return response.text;
//   }
// }
