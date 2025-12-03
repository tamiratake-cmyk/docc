import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
