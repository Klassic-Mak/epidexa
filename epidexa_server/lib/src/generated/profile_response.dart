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
import 'user_profile.dart' as _i2;
import 'package:skinaware_server/src/generated/protocol.dart' as _i3;

abstract class ProfileResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProfileResponse._({
    required this.success,
    this.message,
    this.error,
    this.profile,
  });

  factory ProfileResponse({
    required bool success,
    String? message,
    String? error,
    _i2.UserProfile? profile,
  }) = _ProfileResponseImpl;

  factory ProfileResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProfileResponse(
      success: jsonSerialization['success'] as bool,
      message: jsonSerialization['message'] as String?,
      error: jsonSerialization['error'] as String?,
      profile: jsonSerialization['profile'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.UserProfile>(
              jsonSerialization['profile'],
            ),
    );
  }

  bool success;

  String? message;

  String? error;

  _i2.UserProfile? profile;

  /// Returns a shallow copy of this [ProfileResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProfileResponse copyWith({
    bool? success,
    String? message,
    String? error,
    _i2.UserProfile? profile,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProfileResponse',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (profile != null) 'profile': profile?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProfileResponse',
      'success': success,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProfileResponseImpl extends ProfileResponse {
  _ProfileResponseImpl({
    required bool success,
    String? message,
    String? error,
    _i2.UserProfile? profile,
  }) : super._(
         success: success,
         message: message,
         error: error,
         profile: profile,
       );

  /// Returns a shallow copy of this [ProfileResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProfileResponse copyWith({
    bool? success,
    Object? message = _Undefined,
    Object? error = _Undefined,
    Object? profile = _Undefined,
  }) {
    return ProfileResponse(
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      error: error is String? ? error : this.error,
      profile: profile is _i2.UserProfile? ? profile : this.profile?.copyWith(),
    );
  }
}
