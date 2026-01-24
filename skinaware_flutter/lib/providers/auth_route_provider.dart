import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_flutter/providers/auth_provider.dart';

enum AuthRoute {
  login,
  register,
  mainPage,
  unknown,
}

final authRouteProvider = Provider<AuthRoute>((ref) {
  final authState = ref.watch(authProvider);

  if (authState.isLoading) {
    return AuthRoute.unknown;
  }

  if (authState.isAuthenticated && authState.user != null) {
    return AuthRoute.mainPage;
  }

  return AuthRoute.login;
});
