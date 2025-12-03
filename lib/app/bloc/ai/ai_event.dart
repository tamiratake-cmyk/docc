import 'package:equatable/equatable.dart';

abstract class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class Summarize extends AiEvent {
  final String text;

  const Summarize(this.text);

  @override
  List<Object> get props => [text];
}

class ReWrite extends AiEvent {
  final String instruction;
  final String note;

  const ReWrite(this.instruction, this.note);
  @override
  List<Object> get props => [instruction, note];
}

class Chat extends AiEvent {
  final String question;
  final String note;

  const Chat(this.question, this.note);

  @override
  List<Object> get props => [question, note];
}




