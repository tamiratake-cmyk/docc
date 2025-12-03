import 'package:equatable/equatable.dart';

abstract class AiState extends Equatable{
    const AiState();
    @override
    List<Object> get props => [];
}


class  AiLoading extends AiState{}

class AiInitial extends AiState{}

class AiFailure extends AiState{
  final String error;

   const AiFailure(this.error);

  @override
  List<Object> get props => [error];
}


class AiLoaded extends AiState{
  final String response;

  const AiLoaded(this.response);

  @override
  List<Object> get props => [response];
}

