import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    show defaultGeneratePasswordHash, defaultValidatePasswordHash;

import '../generated/protocol.dart';

class UserEndpoint extends Endpoint {
  // ======================
  // REGISTER / CREATE USER
  // ======================
  Future<AuthResponse> register(
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
      return AuthResponse(
        success: false,
        error: validationError,
        user: null,
      );
    }

    final existing = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    if (existing != null) {
      return AuthResponse(
        success: false,
        error: 'An account with this email already exists.',
        user: null,
      );
    }

    // ✅ Serverpod password hashing
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

      return AuthResponse(
        success: true,
        message: 'Account created successfully.',
        error: null,
        user: inserted,
      );
    } catch (e) {
      session.log('Register failed: $e', level: LogLevel.error);

      return AuthResponse(
        success: false,
        error: 'Internal server error.',
        user: null,
      );
    }
  }

  // =========
  // LOGIN
  // =========
  Future<AuthResponse> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);

    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(normalizedEmail),
    );

    // ✅ Timing-safe fake hash (same cost whether user exists or not)
    final fakeHash = await defaultGeneratePasswordHash(
      'fake_password_for_timing',
    );
    final hashToCheck = user?.passwordHash ?? fakeHash;

    // ✅ Validate password (do NOT cast; treat it as bool)
    final validateResult = await defaultValidatePasswordHash(
      email: normalizedEmail,
      password: password,
      hash: hashToCheck,
    );

    final bool isValid = validateResult == true;

    if (user == null || !isValid) {
      return AuthResponse(
        success: false,
        error: 'Invalid email or password.',
        user: null,
      );
    }

    return AuthResponse(
      success: true,
      message: 'Login successful.',
      error: null,
      user: user,
    );
  }

  // ==================
  // GET USER BY ID
  // ==================
  Future<AuthResponse> getById(
    Session session, {
    required UuidValue userId,
  }) async {
    final user = await User.db.findById(session, userId);

    if (user == null) {
      return AuthResponse(
        success: false,
        error: 'User not found.',
        user: null,
      );
    }

    return AuthResponse(
      success: true,
      user: user,
    );
  }
}

// -----------------------------
// Other helpers
// -----------------------------
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
