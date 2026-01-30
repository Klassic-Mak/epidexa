// user_services.dart
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

class UserServices {
  Future<void> updateUser({
    required BuildContext context,
    required WidgetRef ref,

    // required
    required UuidValue userId,

    // optional updates
    String? email,
    String? password,
    String? phone,
    int? age,
    Gender? gender,
    String? name,
    Role? role,
    SkinType? skinType,
    String? profilePhoto,
  }) async {
    try {
      LoadingDialog.show(context);

      final client = ref.read(serverpodClientProvider);

      final AuthResponse res = await client.user
          .updateUser(
            userId: userId,
            email: email,
            password: password,
            phone: phone,
            age: age,
            gender: gender,
            name: name,
            role: role,
            skinType: skinType,
            profilePhoto: profilePhoto,
          )
          .timeout(const Duration(seconds: 25));

      _closeLoaderSafely(context);

      if (!res.success) {
        showTopToast(
          context,
          (res.error ?? 'Update failed').toString(),
          isSuccess: false,
        );
        return;
      }

      final updatedUser = res.user;

      // ✅ Update local user state if returned
      if (updatedUser != null) {
        // If your notifier has a method like `loginUser` (sets the user),
        // you can reuse it, or create a `setUser` method.
        await ref.read(userProvider.notifier).loginUser(updatedUser);
      }

      showTopToast(
        context,
        (res.message ?? 'Profile updated successfully').toString(),
        isSuccess: true,
      );
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
      _closeLoaderSafely(context);
      // helpful logs
      // ignore: avoid_print
      print('update user error: ${e.runtimeType}');
      // ignore: avoid_print
      print('exception: $e');
      // ignore: avoid_print
      print('stacktrace: $st');

      showTopToast(context, "Unexpected error: $e", isSuccess: false);
    }
  }
}

void _closeLoaderSafely(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
