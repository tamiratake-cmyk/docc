// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/user/user_bloc.dart';
import 'package:flutter_application_1/app/bloc/user/user_event.dart';
import 'package:flutter_application_1/data/helpers/di/injector.dart';
import 'package:flutter_application_1/domain/useCases/get_user_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/mock/mock_api_service.dart';
import 'data/repositories/user_repository_impl.dart';
import 'package:flutter_application_1/domain/useCases/get_user_profile.dart';
import 'package:flutter_application_1/app/navigation.dart';

void main() async {

  // final api = MockApiService();
  // final repository = UserRepositoryImpl(api);
  // final getUserProfile = GetUserProfile(repository);
  // final getUserPosts = GetUserPost(repository);

  // setupInjector();

  // runApp(MyApp(
  //   getUserProfile: sl(),
  //   getUserPosts: sl(),
  // ));

WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
runApp(const NotesApp())


}

// class MyApp extends StatelessWidget {
//   final GetUserProfile getUserProfile;
//   final GetUserPost getUserPosts;

//   const MyApp({
//     super.key,
//     required this.getUserProfile,
//     required this.getUserPosts,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => UserBloc(
//         getUserProfile: sl(),
//         getUserPost: sl(),
//       )..add(LoadUserPosts()),
      
//       child: MaterialApp.router(
//         debugShowCheckedModeBanner: false,
//         title: 'Clean Architecture Demo',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         routerConfig: AppRouter.router,
//       ),
//     );
//   }
// }
