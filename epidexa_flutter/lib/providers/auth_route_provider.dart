import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_flutter/providers/auth_provider.dart';
import 'package:skinaware_flutter/providers/on_boading_provider.dart';

enum AuthRoute {
  onboarding,
  login,
  register,
  mainPage,
  unknown,
}

final authRouteProvider = Provider<AuthRoute>((ref) {
  final authState = ref.watch(authProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  if (authState.isLoading) {
    return AuthRoute.unknown;
  }

  if (authState.isAuthenticated && authState.user != null) {
    return AuthRoute.mainPage;
  }

  // If onboarding hasn't been completed, send the user there first.
  if (!onboardingCompleted) {
    return AuthRoute.onboarding;
  }

  return AuthRoute.login;
});
