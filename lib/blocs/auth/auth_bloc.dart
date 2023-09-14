import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_connection_1/services/auth_service.dart';
import 'package:firebase_connection_1/services/util_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_signUp);
  }

  void _signUp(SignUpEvent event, Emitter emit) async {
    if(!Util.validateRegistration(event.username, event.email, event.password, event.prePassword)) {
      emit(const AuthFailure("Please check your data!"));
      return;
    }

    emit(AuthLoading());

    final result = await AuthService.signUp(event.email, event.password, event.username);
    if(result) {
      emit(SignUpSuccess());
    } else {
      emit(const AuthFailure("Something error, please try again later!!!"));
    }
  }
}
