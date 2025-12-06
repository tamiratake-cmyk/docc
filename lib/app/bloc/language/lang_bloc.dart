import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/language/lang_event.dart';
import 'package:flutter_application_1/app/bloc/language/lang_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangBloc extends Bloc<LangeEvent, LangState> {
  LangBloc() : super(const LangState(locale: Locale('en'))) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadLanguageEvent>(_onLoadLanguage);
  }


  Future<void> _onChangeLanguage(
      ChangeLanguageEvent event, Emitter<LangState> emit) async {
       final prefs = await SharedPreferences.getInstance();

        await prefs.setString('language_code', event.languageCode);

    emit(LangState(locale: event.languageCode.isNotEmpty
        ? Locale(event.languageCode)
        : const Locale('en')));
  }

  Future<void> _onLoadLanguage(
      LoadLanguageEvent event, Emitter<LangState> emit) async {
        final prefs = await SharedPreferences.getInstance();

        final code = prefs.getString('language_code') ?? 'en';
        
        emit(LangState(locale: Locale(code)));

  }

}