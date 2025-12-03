class AIResponse{
  final String response;

  AIResponse(this.response);
}



class AIRequest{
  final String noteText;
  final String instruction;

  AIRequest({ required this.noteText, required this.instruction});
}