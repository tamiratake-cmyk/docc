

import 'package:equatable/equatable.dart';

abstract class LangeEvent extends Equatable {
  const LangeEvent();

  @override
  List<Object> get props => [];
}



class ChangeLanguageEvent extends LangeEvent {
  final String languageCode;

  const ChangeLanguageEvent({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}


class LoadLanguageEvent extends LangeEvent {}