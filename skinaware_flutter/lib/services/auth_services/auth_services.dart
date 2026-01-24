// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:skinaware_client/skinaware_client.dart';

import 'package:skinaware_flutter/general_components/loading_dialog.dart';
import 'package:skinaware_flutter/general_components/pop.dart';
import 'package:skinaware_flutter/providers/serverpod_provider.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

class AuthServices {
  /// REGISTER (serverpod)
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required int age,
    required Gender gender,
    required Role role,
    required SkinType skinType,
    String? profilePhoto,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);

      final res = await client.user
          .register(
            email: email,
            password: password,
            phone: phone,
            age: age,
            gender: gender,
            name: fullName,
            role: role,
            skinType: skinType,
            profilePhoto: profilePhoto,
          )
          .timeout(const Duration(seconds: 25));

      Navigator.of(context).pop(); // close loader

      if (res['success'] != true) {
        showTopToast(
          context,
          (res['error'] ?? 'Registration failed').toString(),
          isSuccess: false,
        );
        return;
      }

      // If you want auto-login after register:
      final userJson = res['user'];
      if (userJson != null) {
        final user = User.fromJson(userJson);
        await ref.read(userProvider.notifier).loginUser(user);
      }

      showTopToast(
        context,
        (res['message'] ?? 'Account created successfully').toString(),
        isSuccess: true,
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, mainPageRoute);
      }
    } on SocketException {
      _closeLoaderSafely(context);
      showTopToast(context, "No internet connection.", isSuccess: false);
    } on TimeoutException {
      _closeLoaderSafely(context);
      showTopToast(context, "Request timed out. Try again.", isSuccess: false);
    } on http.ClientException catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Network error: ${e.message}", isSuccess: false);
    } catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Unexpected error: $e", isSuccess: false);
    }
  }

  /// LOGIN (serverpod)
  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);

      final res = await client.user
          .login(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 25));

      Navigator.of(context).pop(); // close loader

      if (res['success'] != true) {
        showTopToast(
          context,
          (res['error'] ?? 'Invalid email or password').toString(),
          isSuccess: false,
        );
        return;
      }

      final userJson = res['user'];
      if (userJson == null) {
        showTopToast(context, "Login failed: user missing.", isSuccess: false);
        return;
      }

      final user = User.fromJson(userJson);

      await ref.read(userProvider.notifier).loginUser(user);

      showTopToast(context, "Login Successful", isSuccess: true);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, mainPageRoute);
      }
    } on SocketException {
      _closeLoaderSafely(context);
      showTopToast(context, "No internet connection.", isSuccess: false);
    } on TimeoutException {
      _closeLoaderSafely(context);
      showTopToast(context, "Request timed out. Try again.", isSuccess: false);
    } on http.ClientException catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Network error: ${e.message}", isSuccess: false);
    } catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Unexpected error: $e", isSuccess: false);
    }
  }

  /// CHANGE PASSWORD (serverpod)
  Future<void> changePassword({
    required BuildContext context,
    required WidgetRef ref,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);
      final user = ref.read(userProvider);

      if (user == null) {
        Navigator.of(context).pop();
        showTopToast(context, "You are not logged in.", isSuccess: false);
        return;
      }

      final res = await client.user
          .changePassword(
            userId: user.id!,
            currentPassword: currentPassword,
            newPassword: newPassword,
          )
          .timeout(const Duration(seconds: 25));

      Navigator.of(context).pop();

      if (res['success'] != true) {
        showTopToast(
          context,
          (res['error'] ?? 'Failed').toString(),
          isSuccess: false,
        );
        return;
      }

      showTopToast(
        context,
        (res['message'] ?? 'Password updated').toString(),
        isSuccess: true,
      );
    } catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Error: $e", isSuccess: false);
    }
  }

  // /// SIGN OUT (local only, serverpod has no session here)
  // Future<void> signOut(BuildContext context, WidgetRef ref) async {
  //   showLogoutDialog(context, () async {
  //     try {
  //       LoadingDialog.show(context);

  //       // Clear local user state
  //       ref.read(userProvider.notifier).logout();

  //       Navigator.of(context).pop(); // close loader
  //       Navigator.pushReplacementNamed(context, onBoarding1Route);
  //     } on TimeoutException {
  //       _closeLoaderSafely(context);
  //       showTopToast(
  //         context,
  //         "Sign out timed out. Please try again.",
  //         isSuccess: false,
  //       );
  //     } catch (e) {
  //       _closeLoaderSafely(context);
  //       showTopToast(context, "Error signing out.", isSuccess: false);
  //     }
  //   });
  // }

  /// DELETE ACCOUNT (serverpod)
  Future<void> deleteAccount({
    required BuildContext context,
    required WidgetRef ref,
    required String password,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);
      final user = ref.read(userProvider);

      if (user == null) {
        Navigator.of(context).pop();
        showTopToast(context, "You are not logged in.", isSuccess: false);
        return;
      }

      final res = await client.user
          .deleteAccount(
            userId: user.id!,
            password: password,
          )
          .timeout(const Duration(seconds: 25));

      Navigator.of(context).pop();

      if (res['success'] != true) {
        showTopToast(
          context,
          (res['error'] ?? 'Delete failed').toString(),
          isSuccess: false,
        );
        return;
      }

      // Clear local state and route out
      ref.read(userProvider.notifier).logout();

      showTopToast(
        context,
        (res['message'] ?? 'Account deleted').toString(),
        isSuccess: true,
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, onBoarding1Route);
      }
    } catch (e) {
      _closeLoaderSafely(context);
      showTopToast(context, "Error: $e", isSuccess: false);
    }
  }
}

/// helper: safely close loader
void _closeLoaderSafely(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
