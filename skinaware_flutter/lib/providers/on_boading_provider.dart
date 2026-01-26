import 'package:flutter_riverpod/legacy.dart';

/// Holds the current onboarding page index (0..2)
final onboardingIndexProvider = StateProvider<int>((ref) => 0);

/// Optional: track if onboarding is completed (store later with SharedPreferences)
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);
