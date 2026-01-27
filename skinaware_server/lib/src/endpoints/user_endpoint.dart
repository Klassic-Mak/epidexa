import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    show defaultGeneratePasswordHash, defaultValidatePasswordHash;

import 'package:serverpod_auth_server/serverpod_auth_server.dart'
    show defaultValidatePasswordHash, PasswordValidationSuccess;

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

    if (user == null) {
      return AuthResponse(
        success: false,
        error: 'Invalid email or password.',
        user: null,
      );
    }

    final result = await defaultValidatePasswordHash(
      password: password,
      email: normalizedEmail,
      hash: user.passwordHash,
    );

    final isValid = result is PasswordValidationSuccess;

    if (!isValid) {
      return AuthResponse(
        success: false,
        error: 'Invalid email or password.',
        user: null,
      );
    }

    return AuthResponse(
      success: true,
      message: 'Login successful.',
      user: user,
    );
  }

  // ======================
  // UPDATE USER
  // ======================
  Future<AuthResponse> updateUser(
    Session session, {
    required UuidValue userId,

    // Optional updates
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
    // 1) Fetch existing user
    final existingUser = await User.db.findById(session, userId);

    if (existingUser == null) {
      return AuthResponse(
        success: false,
        error: 'User not found.',
        user: null,
      );
    }

    // 2) Clean & normalize inputs (only if provided)
    final normalizedEmail = email != null ? _normalizeEmail(email) : null;
    final cleanPhone = phone?.trim();
    final cleanName = name?.trim();

    // 3) Validate only provided fields
    final validationError = _validateUpdateUser(
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

    // 4) If email is changing, ensure it's not already taken
    if (normalizedEmail != null && normalizedEmail != existingUser.email) {
      final emailTaken = await User.db.findFirstRow(
        session,
        where: (t) => t.email.equals(normalizedEmail),
      );

      if (emailTaken != null) {
        return AuthResponse(
          success: false,
          error: 'An account with this email already exists.',
          user: null,
        );
      }
    }

    // 5) If password provided, hash it
    String? newPasswordHash;
    if (password != null && password.isNotEmpty) {
      newPasswordHash = await defaultGeneratePasswordHash(password);
    }

    // 6) Create updated object (merge: keep old values when null)
    final updatedUser = existingUser.copyWith(
      email: normalizedEmail ?? existingUser.email,
      phone: cleanPhone ?? existingUser.phone,
      age: age ?? existingUser.age,
      gender: gender ?? existingUser.gender,
      name: cleanName ?? existingUser.name,
      role: role ?? existingUser.role,
      skinType: skinType ?? existingUser.skinType,
      profilePhoto: profilePhoto ?? existingUser.profilePhoto,
      passwordHash: newPasswordHash ?? existingUser.passwordHash,
      // keep encryption/description keys unchanged
      // encryptionKey: existingUser.encryptionKey,
      // descriptionKey: existingUser.descriptionKey,
    );

    try {
      final saved = await User.db.updateRow(session, updatedUser);

      return AuthResponse(
        success: true,
        message: 'Profile updated successfully.',
        error: null,
        user: saved,
      );
    } catch (e) {
      session.log('Update user failed: $e', level: LogLevel.error);

      return AuthResponse(
        success: false,
        error: 'Internal server error.',
        user: null,
      );
    }
  }

  // -----------------------------
  // Update validation helper
  // -----------------------------
  String? _validateUpdateUser({
    String? email,
    String? password,
    String? phone,
    int? age,
    String? name,
  }) {
    if (email != null && !_isValidEmail(email)) {
      return 'Invalid email address.';
    }
    if (password != null && password.isNotEmpty && password.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (phone != null && (phone.isEmpty || phone.length < 7)) {
      return 'Invalid phone number.';
    }
    if (name != null && name.isNotEmpty && name.length < 2) {
      return 'Name is too short.';
    }
    if (age != null && (age < 1 || age > 120)) {
      return 'Invalid age.';
    }
    return null;
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

  // ==================
  // UPDATE USER PROFILE
  // ==================
  Future<AuthResponse> updateProfile(
    Session session, {
    required UuidValue userId,
    String? name,
    String? phone,
    int? age,
    Gender? gender,
    Role? role,
    SkinType? skinType,
    String? profilePhoto,
  }) async {
    final user = await User.db.findById(session, userId);

    if (user == null) {
      return AuthResponse(
        success: false,
        error: 'User not found.',
        user: null,
      );
    }

    // Validate inputs if provided
    if (name != null && name.trim().length < 2) {
      return AuthResponse(
        success: false,
        error: 'Name is too short.',
        user: null,
      );
    }

    if (phone != null && (phone.trim().isEmpty || phone.trim().length < 7)) {
      return AuthResponse(
        success: false,
        error: 'Invalid phone number.',
        user: null,
      );
    }

    if (age != null && (age < 1 || age > 120)) {
      return AuthResponse(
        success: false,
        error: 'Invalid age.',
        user: null,
      );
    }

    // Update user with new values
    final updatedUser = user.copyWith(
      name: name?.trim() ?? user.name,
      phone: phone?.trim() ?? user.phone,
      age: age ?? user.age,
      gender: gender ?? user.gender,
      role: role ?? user.role,
      skinType: skinType ?? user.skinType,
      profilePhoto: profilePhoto ?? user.profilePhoto,
    );

    try {
      final saved = await User.db.updateRow(session, updatedUser);

      return AuthResponse(
        success: true,
        message: 'Profile updated successfully.',
        user: saved,
      );
    } catch (e) {
      session.log('Update profile failed: $e', level: LogLevel.error);

      return AuthResponse(
        success: false,
        error: 'Failed to update profile.',
        user: null,
      );
    }
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
