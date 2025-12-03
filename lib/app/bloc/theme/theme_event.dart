import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';

abstract class ThemeEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final AppThemeMode theme;

  ChangeTheme(this.theme);

  @override
  List<Object> get props => [theme];
}



class LoadTheme extends ThemeEvent {}