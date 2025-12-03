import 'package:flutter_application_1/domain/entities/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRepository{
    static const String _themeKey = 'app_theme';


    Future<void>  saveThemeMode(AppThemeMode themeMode) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeMode.toString());
    }

    Future<AppThemeMode> loadThemeMode() async {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(_themeKey);
      if (themeString != null) {
        return AppThemeMode.values.firstWhere(
          (e) => e.toString() == themeString,
          orElse: () => AppThemeMode.system,
        );
      }
      return AppThemeMode.system;
    }
}