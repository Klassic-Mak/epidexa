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

      // ✅ Now returns AuthResponse (typed)
      final AuthResponse res = await client.user
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

      _closeLoaderSafely(context);

      // Debug
      print('registration success: ${res.success}');
      print('registration message: ${res.message}');
      print('registration error: ${res.error}');
      print('registration user: ${res.user}');

      if (!res.success) {
        showTopToast(
          context,
          (res.error ?? 'Registration failed').toString(),
          isSuccess: false,
        );
        return;
      }

      final user = res.user;
      if (user != null) {
        await ref.read(userProvider.notifier).loginUser(user);
      }

      showTopToast(
        context,
        (res.message ?? 'Account created successfully').toString(),
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
    } catch (e, st) {
      print('user registration error: ${e.runtimeType}');
      print('exception: $e');
      print('stacktrace: $st');
      _closeLoaderSafely(context);
      showTopToast(context, "Unexpected error: $e", isSuccess: false);
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);

      // ✅ Now returns AuthResponse (typed)
      final AuthResponse res = await client.user
          .login(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 25));

      _closeLoaderSafely(context);

      if (!res.success) {
        showTopToast(
          context,
          (res.error ?? 'Invalid email or password').toString(),
          isSuccess: false,
        );
        return;
      }

      final user = res.user;
      if (user == null) {
        showTopToast(context, "Login failed: user missing.", isSuccess: false);
        return;
      }

      await ref.read(userProvider.notifier).loginUser(user);

      showTopToast(context, res.message ?? "Login Successful", isSuccess: true);

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
    } catch (e, st) {
      print('user login error: ${e.runtimeType}');
      print('exception: $e');
      print('stacktrace: $st');
      _closeLoaderSafely(context);
      showTopToast(context, "Unexpected error: $e", isSuccess: false);
    }
  }
}

void _closeLoaderSafely(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
