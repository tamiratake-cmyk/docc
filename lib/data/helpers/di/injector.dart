import 'package:flutter_application_1/data/mock/mock_api_service.dart';
import 'package:flutter_application_1/data/repositories/user_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/user_repository.dart';
import 'package:flutter_application_1/domain/useCases/get_user_post.dart';
import 'package:flutter_application_1/domain/useCases/get_user_profile.dart';
import 'package:get_it/get_it.dart';



final sl = GetIt.instance;

void setupInjector() {
  // Here you can register your dependencies, for example:
 sl.registerLazySingleton<MockApiService>(() => MockApiService());

  // sl.registerLazySingleton<YourService>(() => YourServiceImpl());
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(sl<MockApiService>()));

sl.registerLazySingleton(()=>GetUserPost(sl()))

;  sl.registerLazySingleton(()=>GetUserProfile(sl()));
}

