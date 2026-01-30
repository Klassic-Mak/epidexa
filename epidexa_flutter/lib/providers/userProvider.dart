import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:skinaware_client/skinaware_client.dart';

/// StateNotifier holds a single logged-in user (or null if logged out)
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  bool get isLoggedIn => state != null;

  /// Save user after login/register
  Future<void> loginUser(User user) async {
    state = user;
  }

  /// Optional: when you want to update user object in memory
  void updateUser(User user) {
    state = user;
  }

  /// Clear user on logout
  void logout() {
    state = null;
  }

  /// Update only a few fields (useful after updateProfile)
  void updateProfile({
    String? name,
    String? phone,
    int? age,
    Gender? gender,
    Role? role,
    SkinType? skinType,
    String? profilePhoto,
  }) {
    final current = state;
    if (current == null) return;

    state = current.copyWith(
      name: name ?? current.name,
      phone: phone ?? current.phone,
      age: age ?? current.age,
      gender: gender ?? current.gender,
      role: role ?? current.role,
      skinType: skinType ?? current.skinType,
      profilePhoto: profilePhoto ?? current.profilePhoto,
    );
  }

  /// Helper if your endpoint returns Map<String, dynamic> with user json
  /// e.g. res['user']
  void setUserFromResponse(Map<String, dynamic> res) {
    final userJson = res['user'];
    if (userJson == null) return;

    // NOTE: If your generated code doesn't have fromJson,
    // change this line to the correct method in your generated User model.
    state = User.fromJson(userJson);
  }
}

/// Riverpod provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
