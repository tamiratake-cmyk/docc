import 'package:flutter_application_1/app/bloc/theme/theme_event.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_state.dart';
import 'package:flutter_application_1/data/repositories/theme_repo.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
    final ThemeRepository themeRepository;

  ThemeBloc(this.themeRepository) : super(const ThemeState(theme: AppThemeMode.system)) {
    Future<void> _onChange(ChangeTheme event, Emitter<ThemeState> emit) async {
      emit(ThemeState(theme: event.theme));

      await themeRepository.saveThemeMode(event.theme);
    }

    Future<void> _onLoad(event, Emitter<ThemeState> emit) async {
      final saved = await themeRepository.loadThemeMode();

      AppThemeMode theme = AppThemeMode.system;

      if (saved == 'light') theme = AppThemeMode.light;
      if (saved == 'dark') theme = AppThemeMode.dark;

      emit(ThemeState(theme: theme));
    }

    on<ChangeTheme>(_onChange);
    on<LoadTheme>(_onLoad);
  }
}