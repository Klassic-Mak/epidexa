/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'user.dart' as _i2;
import 'package:skinaware_server/src/generated/protocol.dart' as _i3;

abstract class AuthResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AuthResponse._({
    required this.success,
    this.message,
    this.error,
    this.user,
  });

  factory AuthResponse({
    required bool success,
    String? message,
    String? error,
    _i2.User? user,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String?,
      error: jsonSerialization['error'] as String?,
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
    );
  }

  bool success;

  String? message;

  String? error;

  _i2.User? user;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthResponse copyWith({
    bool? success,
    String? message,
    String? error,
    _i2.User? user,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (user != null) 'user': user?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (user != null) 'user': user?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required bool success,
    String? message,
    String? error,
    _i2.User? user,
  }) : super._(
         success: success,
         message: message,
         error: error,
         user: user,
       );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthResponse copyWith({
    bool? success,
    Object? message = _Undefined,
    Object? error = _Undefined,
    Object? user = _Undefined,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      error: error is String? ? error : this.error,
      user: user is _i2.User? ? user : this.user?.copyWith(),
    );
  }
}
