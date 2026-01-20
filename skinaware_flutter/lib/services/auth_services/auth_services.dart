// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:skinaware_flutter/general_components/loading_dialog.dart';
import 'package:skinaware_flutter/general_components/pop.dart';
import 'package:skinaware_flutter/providers/userProvider.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final UserServices _userServices = UserServices();

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,

    required BuildContext context,
  }) async {
    try {
      // Show loading dialog
      LoadingDialog.show(context);

      // Create user with Firebase
      final result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 20));

      final firebaseUser = result.user;

      // Firebase user null check
      if (firebaseUser == null) {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Sign up failed. Please try again.",
          isSuccess: false,
        );
        return;
      }

      // Send email verification
      await firebaseUser.sendEmailVerification();

      Navigator.of(context).pop();
      showTopToast(
        context,
        "Account created! Please verify your email.",
        isSuccess: true,
      );

      // Navigate back or to verification screen
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      switch (e.code) {
        case 'invalid-email':
          showTopToast(context, "Invalid email format.", isSuccess: false);
          break;
        case 'email-already-in-use':
          showTopToast(
            context,
            "Email already in use. Please try another.",
            isSuccess: false,
          );
          break;
        case 'weak-password':
          showTopToast(
            context,
            "Password is too weak. Use a stronger password.",
            isSuccess: false,
          );
          break;
        case 'operation-not-allowed':
          showTopToast(
            context,
            "Operation not allowed. Contact support.",
            isSuccess: false,
          );
          break;
        case 'too-many-requests':
          showTopToast(
            context,
            "Too many attempts. Please try again later.",
            isSuccess: false,
          );
          break;
        case 'network-request-failed':
          showTopToast(
            context,
            "Network error. Check your internet.",
            isSuccess: false,
          );
          break;
        default:
          showTopToast(
            context,
            "Sign up failed: ${e.message}",
            isSuccess: false,
          );
          break;
      }

      return;
    } on SocketException {
      Navigator.of(context).pop();
      showTopToast(context, "No internet connection.", isSuccess: false);
      return;
    } on TimeoutException {
      Navigator.of(context).pop();
      showTopToast(context, "Request timed out. Try again.", isSuccess: false);
      return;
    } catch (e) {
      Navigator.of(context).pop();
      showTopToast(
        context,
        "Unexpected error: ${e.toString()}",
        isSuccess: false,
      );
      return;
    }
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      // Show loading dialog
      LoadingDialog.show(context);

      // Sign in with Firebase
      final result = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 20));

      final firebaseUser = result.user;

      // Firebase user null check
      if (firebaseUser == null) {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Login failed. Please try again.",
          isSuccess: false,
        );
        return null;
      }

      // Email verification check
      if (!firebaseUser.emailVerified) {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Please verify your email to continue.",
          isSuccess: false,
        );
        return null;
      }

      // // Fetch user from backend
      // final userAPI = await _userServices.getUserByFirebaseUid();
      // if (userAPI == null) {
      //   Navigator.of(context).pop();
      //   showTopToast(context, "User not found in system.", isSuccess: false);
      //   return null;
      // }

      // // Login successful
      // await ref.read(userProvider.notifier).loginUser(userAPI);
      Navigator.of(context).pop();
      showTopToast(context, "Login Successful", isSuccess: true);

      // Navigate to main page
      if (context.mounted) {
        Navigator.pushNamed(context, mainPageRoute);
      }

      // return userAPI;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();

      switch (e.code) {
        case 'invalid-email':
          showTopToast(context, "Invalid email format.", isSuccess: false);
          break;
        case 'user-not-found':
          showTopToast(
            context,
            "No user found with that email.",
            isSuccess: false,
          );
          break;
        case 'wrong-password':
          showTopToast(
            context,
            "Incorrect password entered.",
            isSuccess: false,
          );
          break;
        case 'user-disabled':
          showTopToast(
            context,
            "This user account is disabled.",
            isSuccess: false,
          );
          break;
        case 'too-many-requests':
          showTopToast(
            context,
            "Too many attempts. Please try again later.",
            isSuccess: false,
          );
          break;
        case 'network-request-failed':
          showTopToast(
            context,
            "Network error. Check your internet.",
            isSuccess: false,
          );
          break;
        case 'invalid-credential':
          showTopToast(context, "Wrong email or password.", isSuccess: false);
          break;
        case 'operation-not-allowed':
          showTopToast(
            context,
            "Operation not allowed. Contact support.",
            isSuccess: false,
          );
          break;
        default:
          showTopToast(context, "Login failed: ${e.message}", isSuccess: false);
          break;
      }

      return null;
    } on SocketException {
      Navigator.of(context).pop();
      showTopToast(context, "No internet connection.", isSuccess: false);
      return null;
    } on TimeoutException {
      Navigator.of(context).pop();
      showTopToast(context, "Request timed out. Try again.", isSuccess: false);
      return null;
    } catch (e) {
      Navigator.of(context).pop();
      showTopToast(
        context,
        "Unexpected error: ${e.toString()}",
        isSuccess: false,
      );
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      LoadingDialog.show(context);
      UserCredential userCredential;

      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
        ..setCustomParameters({'prompt': 'select_account'})
        ..addScope('email');

      userCredential = await FirebaseAuth.instance.signInWithPopup(
        googleProvider,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Navigator.of(context).pop();
        showTopToast(context, "Google sign-in failed.", isSuccess: false);
        return null;
      }

      // var userAPI = await _userServices.getUserByFirebaseUid();

      // // If not, create the user in your backend
      // if (userAPI == null) {
      //   Navigator.of(context).pop();
      //   showTopToast(context, "User not found in system.", isSuccess: false);
      //   return null;
      // }

      // // ✅ Set user in provider
      // await ref.read(userProvider.notifier).loginUser(userAPI);
      Navigator.of(context).pop();
      showTopToast(context, "Login Successful", isSuccess: true);

      if (context.mounted) {
        Navigator.pushNamed(context, mainPageRoute);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showTopToast(
        context,
        "Google sign-in failed: ${e.message}",
        isSuccess: false,
      );
      return null;
    } catch (e, stackTrace) {
      Navigator.of(context).pop();
      showTopToast(context, "Google sign-in failed: $e", isSuccess: false);
      return null;
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      LoadingDialog.show(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pop();
      showTopToast(context, 'Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      switch (e.code) {
        case 'invalid-email':
          showTopToast(
            context,
            'The email address is invalid.',
            isSuccess: false,
          );
          break;
        case 'user-not-found':
          showTopToast(
            context,
            'No user found with this email.',
            isSuccess: false,
          );
          break;
        case 'missing-email':
          showTopToast(
            context,
            'Please provide an email address.',
            isSuccess: false,
          );
          break;
        default:
          showTopToast(context, 'Error: ${e.message}', isSuccess: false);
          break;
      }
    } catch (e) {
      showTopToast(
        context,
        'Something went wrong. Please try again.',
        isSuccess: false,
      );
      print('Unexpected error: $e');
    }
  }

  Future<void> signOut(BuildContext context, WidgetRef ref) async {
    showLogoutDialog(context, () async {
      try {
        LoadingDialog.show(context);
        await _auth.signOut().timeout(Duration(seconds: 30));
        // await ref.read(userProvider.notifier).logoutUser();
        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, onBoarding1Route);
      } on TimeoutException {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Sign out timed out. Please try again.",
          isSuccess: false,
        );
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Error signing out: ${e.message}",
          isSuccess: false,
        );
      } on http.ClientException catch (e) {
        Navigator.of(context).pop();
        showTopToast(
          context,
          "Network error during sign out: ${e.message}",
          isSuccess: false,
        );
      } catch (e) {
        Navigator.of(context).pop();
        showTopToast(context, "Error signing out.", isSuccess: false);
      }
    });
  }
}

void showLogoutDialog(BuildContext context, void Function() onLogout) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with soft background
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  "Are you sure want to Logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onLogout();
                        },
                        child: const Text(
                          "Yes, Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
