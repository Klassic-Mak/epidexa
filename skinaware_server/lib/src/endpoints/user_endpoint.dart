import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    show
        defaultGeneratePasswordHash,
        defaultValidatePasswordHash,
        PasswordValidationSuccess;

import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  Future<Map<String, dynamic>> register(
    Session session, {
    required String email,
    required String password,
    required String phone,
    required int age,
    required Gender gender,
    required String name,
    required Role role,
    required SkinType skinType,
    String? profilePhoto,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final cleanPhone = phone.trim();
    final cleanName = name.trim();

    final validationError = _validateRegister(
      email: normalizedEmail,
      password: password,
      phone: cleanPhone,
      age: age,
      name: cleanName,
    );

    if (validationError != null) {
      return {
        'success': false,
        'error': validationError,
        'user': null,
      };
    }

    final existing = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    if (existing != null) {
      return {
        'success': false,
        'error': 'An account with this email already exists.',
        'user': null,
      };
    }

    final passwordHash = await defaultGeneratePasswordHash(password);

    final user = User(
      email: normalizedEmail,
      phone: cleanPhone,
      age: age,
      gender: gender,
      passwordHash: passwordHash,
      name: cleanName,
      role: role,
      skinType: skinType,
      profilePhoto: profilePhoto,
      encryptionKey: _randomKey(),
      descriptionKey: _randomKey(),
      createdAt: DateTime.now().toUtc(),
    );

    try {
      final inserted = await User.db.insertRow(session, user);

      return {
        'success': true,
        'message': 'Account created successfully.',
        'user': inserted,
      };
    } catch (e) {
      session.log('Register failed: $e', level: LogLevel.error);

      return {
        'success': false,
        'error': 'Internal server error.',
        'user': null,
      };
    }
  }

  Future<Map<String, dynamic>> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    if (user == null) {
      return {
        'success': false,
        'error': 'Invalid email or password.',
        'user': null,
      };
    }

    final result = await defaultValidatePasswordHash(
      email: user.email,
      hash: user.passwordHash,
      password: password,
    );

    if (result is! PasswordValidationSuccess) {
      return {
        'success': false,
        'error': 'Invalid email or password.',
        'user': null,
      };
    }

    return {
      'success': true,
      'message': 'Login successful.',
      'user': user,
    };
  }

  Future<Map<String, dynamic>> getById(
    Session session, {
    required UuidValue userId,
  }) async {
    final user = await User.db.findById(session, userId);

    if (user == null) {
      return {
        'success': false,
        'error': 'User not found.',
        'user': null,
      };
    }

    return {
      'success': true,
      'user': user,
    };
  }

  Future<Map<String, dynamic>> updateProfile(
    Session session, {
    required UuidValue userId,
    String? phone,
    int? age,
    Gender? gender,
    String? name,
    Role? role,
    SkinType? skinType,
    String? profilePhoto,
  }) async {
    final user = await User.db.findById(session, userId);

    if (user == null) {
      return {
        'success': false,
        'error': 'User not found.',
        'user': null,
      };
    }

    if (phone != null && phone.trim().length < 7) {
      return {
        'success': false,
        'error': 'Invalid phone number.',
        'user': null,
      };
    }

    if (name != null && name.trim().length < 2) {
      return {
        'success': false,
        'error': 'Name is too short.',
        'user': null,
      };
    }

    if (age != null && (age < 1 || age > 120)) {
      return {
        'success': false,
        'error': 'Invalid age.',
        'user': null,
      };
    }

    final updated = user.copyWith(
      phone: phone?.trim() ?? user.phone,
      age: age ?? user.age,
      gender: gender ?? user.gender,
      name: name?.trim() ?? user.name,
      role: role ?? user.role,
      skinType: skinType ?? user.skinType,
      profilePhoto: profilePhoto ?? user.profilePhoto,
    );

    final saved = await User.db.updateRow(session, updated);

    return {
      'success': true,
      'message': 'Profile updated.',
      'user': saved,
    };
  }

  Future<Map<String, dynamic>> changePassword(
    Session session, {
    required UuidValue userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      return {
        'success': false,
        'error': 'Password must be at least 8 characters.',
        'user': null,
      };
    }

    final user = await User.db.findById(session, userId);

    if (user == null) {
      return {
        'success': false,
        'error': 'User not found.',
        'user': null,
      };
    }
    final result = await defaultValidatePasswordHash(
      email: user.email,
      hash: user.passwordHash,
      password: currentPassword,
    );

    if (result is! PasswordValidationSuccess) {
      return {
        'success': false,
        'error': 'Current password is incorrect.',
        'user': null,
      };
    }

    final newHash = await defaultGeneratePasswordHash(newPassword);
    final updated = user.copyWith(passwordHash: newHash);

    await User.db.updateRow(session, updated);

    return {
      'success': true,
      'message': 'Password updated successfully.',
      'user': null,
    };
  }

  Future<Map<String, dynamic>> deleteAccount(
    Session session, {
    required UuidValue userId,
    required String password,
  }) async {
    final user = await User.db.findById(session, userId);

    if (user == null) {
      return {
        'success': false,
        'error': 'User not found.',
        'user': null,
      };
    }

    final result = await defaultValidatePasswordHash(
      email: user.email,
      hash: user.passwordHash,
      password: password,
    );

    if (result is! PasswordValidationSuccess) {
      return {
        'success': false,
        'error': 'Invalid password.',
        'user': null,
      };
    }

    await User.db.deleteRow(session, user);

    return {
      'success': true,
      'message': 'Account deleted successfully.',
      'user': null,
    };
  }
}

String _normalizeEmail(String email) => email.trim().toLowerCase();

bool _isValidEmail(String email) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);

String? _validateRegister({
  required String email,
  required String password,
  required String phone,
  required int age,
  required String name,
}) {
  if (!_isValidEmail(email)) return 'Invalid email address.';
  if (password.length < 8) return 'Password must be at least 8 characters.';
  if (phone.isEmpty || phone.length < 7) return 'Invalid phone number.';
  if (name.length < 2) return 'Name is too short.';
  if (age < 1 || age > 120) return 'Invalid age.';
  return null;
}

String _randomKey({int bytes = 32}) {
  final rnd = Random.secure();
  final data = List<int>.generate(bytes, (_) => rnd.nextInt(256));
  return base64UrlEncode(data);
}
