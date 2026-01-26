import 'package:skinaware_client/skinaware_client.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final String? error;
  final User? user;

  AuthResponse({
    required this.success,
    this.message,
    this.error,
    this.user,
  });

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    final userJson = map['user'];
    return AuthResponse(
      success: map['success'] == true,
      message: map['message']?.toString(),
      error: map['error']?.toString(),
      user: (userJson is Map<String, dynamic>) ? User.fromJson(userJson) : null,
    );
  }
}
