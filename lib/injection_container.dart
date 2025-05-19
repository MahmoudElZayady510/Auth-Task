import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/auth/repository/auth_repository.dart';
import '../domain/auth/use_cases/logout_user.dart';
import '../domain/auth/use_cases/register_user.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // Firebase instances
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(
      sl<FirebaseAuth>(),
      sl<FirebaseFirestore>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUserUsecase(sl()));
}
