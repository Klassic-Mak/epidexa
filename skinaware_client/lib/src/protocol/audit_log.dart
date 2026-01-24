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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AuditLog implements _i1.SerializableModel {
  AuditLog._({
    _i1.UuidValue? id,
    required this.userId,
    required this.action,
    required this.ip,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory AuditLog({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String action,
    required String ip,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      action: jsonSerialization['action'] as String,
      ip: jsonSerialization['ip'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i1.UuidValue userId;

  String action;

  String ip;

  String encryptionKey;

  String descriptionKey;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLog copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? action,
    String? ip,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'action': action,
      'ip': ip,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String action,
    required String ip,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         action: action,
         ip: ip,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLog copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? action,
    String? ip,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuditLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      ip: ip ?? this.ip,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
