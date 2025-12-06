import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform, PlatformDispatcher;
import 'package:flutter_application_1/app/bloc/language/lang_bloc.dart';
import 'package:flutter_application_1/app/bloc/language/lang_event.dart';
import 'package:flutter_application_1/app/bloc/language/lang_state.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_bloc.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_event.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_state.dart';
import 'package:flutter_application_1/app/theme/app_theme.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:flutter_application_1/domain/entities/theme.dart';
import 'package:flutter_application_1/utils/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/app/navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   
  //  if (!kIsWeb) {
  //   try {
  //     if (File('.env').existsSync()) {
  //       await dotenv.load(fileName: '.env');
  //     } else {
  //       print('.env not found — continuing without it');
  //     }
  //   } catch (e) {
  //     print('dotenv load failed: $e');
  //   }
  // } else {
  //   // On web you typically inject env variables at build time or use --dart-define
  //   print('Running on web; dotenv skipped');
  // }
      
  await dotenv.load(fileName: '.env');

  await NotificationService.init();

  await setupInjector(); // Initialize Dependency Injection (now async for Hive)
  
  try {
    // Only attempt to initialize Firebase on platforms we've configured.
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      
      PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );  
      
    } else {
      // Linux or other unsupported desktop platforms: skip initialization.
      // If you need Firebase on Linux, run `flutterfire configure` with linux
      // and ensure desktop plugin implementations are available.
      print('Skipping Firebase initialization on this platform.');
    }
  } catch (e, st) {
    // Log but don't crash the app if Firebase can't be initialized.
    print('Firebase initialization failed: $e');
    print(st);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => sl<ThemeBloc>()..add(LoadTheme()),

        ),
        BlocProvider<LangBloc>(
          create: (_) => sl<LangBloc>()..add(LoadLanguageEvent()),    
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          ThemeData themeMode;
          switch (themeState.theme) {
            case AppThemeMode.light:
              themeMode = AppTheme.lightTheme;
              break;
            case AppThemeMode.dark:
              themeMode = AppTheme.darkTheme;
              break;
            case AppThemeMode.system:
            default:
              themeMode =  MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
          }

          return BlocBuilder<LangBloc, LangState>(
            builder: (context, langState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: themeMode,
                routerConfig: AppRouter.router,
                locale: langState.locale,
                supportedLocales: AppLocalizations.supportedLocales,

                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

              );
            },
          );
        },
      ),
    );
  }
}

