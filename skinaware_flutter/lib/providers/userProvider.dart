// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class UserNotifier extends StateNotifier<User?> {
//   final Ref ref;
//   UserNotifier(this.ref) : super(null);

//   /// Login user and update state
//   Future<void> loginUser(User user) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_logged_in', true);
//       state = user;
//     } catch (e) {
//       print(" Error logging in (notifier): $e");
//     }
//   }

//   Future<void> logoutUser() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool('is_logged_in', false);
//       state = null;
//     } catch (e) {
//       print(" Error logging out (notifier): $e");
//     }
//   }

//   Future<void> refreshProvider(User user) async {
//     try {
//       state = user;
//     } catch (e) {
//       print(" Error updating user (notifier): $e");
//     }
//   }

//   Future<bool> checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool('is_logged_in') ?? false;
//   }
// }

// final userProvider = StateNotifierProvider<UserNotifier, User?>(
//   (ref) => UserNotifier(ref),
// );
