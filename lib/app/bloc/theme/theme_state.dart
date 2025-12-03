import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';

class ThemeState extends Equatable {
  final AppThemeMode theme;

  const ThemeState({required this.theme});

  ThemeState copyWith({AppThemeMode? theme}) {
    return ThemeState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object> get props => [theme];

}