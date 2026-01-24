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

abstract class Consent implements _i1.SerializableModel {
  Consent._({
    _i1.UuidValue? id,
    required this.userId,
    required this.type,
    required this.accepted,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.createdAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Consent({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String type,
    required bool accepted,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) = _ConsentImpl;

  factory Consent.fromJson(Map<String, dynamic> jsonSerialization) {
    return Consent(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      type: jsonSerialization['type'] as String,
      accepted: jsonSerialization['accepted'] as bool,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i1.UuidValue userId;

  String type;

  bool accepted;

  String encryptionKey;

  String descriptionKey;

  DateTime createdAt;

  /// Returns a shallow copy of this [Consent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Consent copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? type,
    bool? accepted,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Consent',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'type': type,
      'accepted': accepted,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ConsentImpl extends Consent {
  _ConsentImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String type,
    required bool accepted,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         accepted: accepted,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Consent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Consent copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? type,
    bool? accepted,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  }) {
    return Consent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      accepted: accepted ?? this.accepted,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
