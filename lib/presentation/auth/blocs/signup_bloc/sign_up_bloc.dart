import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/auth/repository/auth_repository.dart';
import '../../../../domain/auth/use_cases/register_user.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase signUpUseCase;
  final AuthRepository authRepository;

  SignUpBloc(this.signUpUseCase, this.authRepository) : super(SignUpInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignUpRequested>(_onGoogleSignIn);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {

    try {
      await signUpUseCase.call(event.email, event.password, event.firstName,
          event.lastName, event.address);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(e.toString()));
    }
  }
  void _onGoogleSignIn( GoogleSignUpRequested event,
      Emitter<SignUpState> emit,) async {
    emit(SignUpLoading());
    final user = await authRepository.signInWithGoogle();
    if (user != null) {
      emit(SignUpSuccess());
    } else {
      emit(SignUpFailure("Something went wrong"));
    }
  }
}
