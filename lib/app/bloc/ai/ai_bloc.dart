import 'package:flutter_application_1/app/bloc/ai/ai_event.dart';
import 'package:flutter_application_1/app/bloc/ai/ai_state.dart';
import 'package:flutter_application_1/domain/entities/ai.dart';
import 'package:flutter_application_1/domain/repositories/ai_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiBloc extends Bloc<AiEvent, AiState> {
  final AiRepository aiRepository;

  AiBloc({required this.aiRepository}) : super(AiInitial()) {
      on<Summarize>(_onSummarize);
      on<ReWrite>(_onRewrite);  
      on<Chat>(_onChat);
  }

  Future<void> _onSummarize(Summarize event, Emitter<AiState> emit) async {
    emit(AiLoading());
    try {
      final  response = await aiRepository.summarize(event.text);
      emit(AiLoaded(response.response));
    } catch (e) {
      emit(AiFailure(e.toString()));
    }
  }


  Future<void> _onRewrite(ReWrite event, Emitter<AiState> emit) async {
    emit(AiLoading());
    try {
      final response = await aiRepository.rewrite(event.note, event.instruction);
      emit(AiLoaded(response.response));
    } catch (e) {
      emit(AiFailure(e.toString()));
    }
  }


  Future<void> _onChat(Chat event, Emitter<AiState> emit) async {
    emit(AiLoading());
    try {
      final response = await aiRepository.chat(event.note, event.question);
      emit(AiLoaded(response.response));
    } catch (e) {
      emit(AiFailure(e.toString()));
    }
  }


}