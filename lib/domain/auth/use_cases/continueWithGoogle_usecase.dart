import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/auth/repository/auth_repository.dart';

class ContinueWithGoogleUsecase{
  final AuthRepository repository;

  ContinueWithGoogleUsecase({required this.repository});
  Future<User?> call(){
    return repository.signInWithGoogle();
  }
}