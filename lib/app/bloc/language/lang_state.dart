import 'package:flutter/widgets.dart';

import 'package:equatable/equatable.dart';

class LangState  extends Equatable {
  final Locale locale;

  const LangState({required this.locale});

  @override
  List<Object> get props => [locale];
}