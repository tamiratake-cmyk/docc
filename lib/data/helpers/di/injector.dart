import 'package:flutter_application_1/app/bloc/notes/notes_bloc.dart';
import 'package:flutter_application_1/app/bloc/theme/theme_bloc.dart';
import 'package:flutter_application_1/data/mock/mock_api_service.dart';
import 'package:flutter_application_1/data/repositories/ai_repo.dart';
import 'package:flutter_application_1/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/data/repositories/notes_repo_impl.dart';
import 'package:flutter_application_1/data/repositories/theme_repo.dart';
import 'package:flutter_application_1/data/repositories/user_repository_impl.dart';
import 'package:flutter_application_1/data/services/note_service.dart';
import 'package:flutter_application_1/domain/repositories/ai_repo.dart';
import 'package:flutter_application_1/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/domain/repositories/note_repository.dart';
import 'package:flutter_application_1/domain/repositories/user_repository.dart';
import 'package:flutter_application_1/domain/useCases/get_user_post.dart';
import 'package:flutter_application_1/domain/useCases/get_user_profile.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/app/bloc/ai/ai_bloc.dart';


final sl = GetIt.instance;

String apiKey = dotenv.env['GROK_API'] ?? '';

void setupInjector() {
  // Services
  sl.registerLazySingleton<MockApiService>(() => MockApiService());
  sl.registerLazySingleton<NoteService>(() => NoteService());

  // Repositories
  sl.registerLazySingleton<NoteRepository>(() => NotesRepoImpl(noteService: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl<MockApiService>()));

//ai repo
sl.registerLazySingleton<AiRepository>(() => GroqAIRepositoryImpl(apiKey));

sl.registerLazySingleton<ThemeRepository>(() => ThemeRepository());
  // UseCases
  sl.registerLazySingleton(() => GetUserPost(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // Blocs
  sl.registerFactory(() => NotesBloc(noteRepository: sl(), authRepository: sl()));
  sl.registerFactory(() => AiBloc(aiRepository: sl()));


  sl.registerFactory(() => ThemeBloc(sl()));
}

