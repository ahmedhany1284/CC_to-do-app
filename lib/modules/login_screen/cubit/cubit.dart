import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState { authenticated, unauthenticated }

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unauthenticated);

  void signIn() {
    // Perform the sign-in logic here
    // You can emit AuthState.authenticated when sign-in is successful
    emit(AuthState.authenticated);
  }

  void signOut() {
    // Perform the sign-out logic here
    // You can emit AuthState.unauthenticated when sign-out is successful
    emit(AuthState.unauthenticated);
  }
}
