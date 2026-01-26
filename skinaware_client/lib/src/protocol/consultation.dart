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
import 'enums/consultation_status.dart' as _i2;

abstract class Consultation implements _i1.SerializableModel {
  Consultation._({
    this.id,
    required this.userId,
    required this.doctorId,
    required this.checkId,
    required this.status,
    required this.doctorNotesKey,
    required this.encryptionKey,
    required this.createdAt,
    this.respondedAt,
  });

  factory Consultation({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue doctorId,
    required _i1.UuidValue checkId,
    required _i2.ConsultationStatus status,
    required String doctorNotesKey,
    required String encryptionKey,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) = _ConsultationImpl;

  factory Consultation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Consultation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      doctorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['doctorId'],
      ),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      status: _i2.ConsultationStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      doctorNotesKey: jsonSerialization['doctorNotesKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i1.UuidValue doctorId;

  _i1.UuidValue checkId;

  _i2.ConsultationStatus status;

  String doctorNotesKey;

  String encryptionKey;

  DateTime createdAt;

  DateTime? respondedAt;

  /// Returns a shallow copy of this [Consultation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Consultation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? doctorId,
    _i1.UuidValue? checkId,
    _i2.ConsultationStatus? status,
    String? doctorNotesKey,
    String? encryptionKey,
    DateTime? createdAt,
    DateTime? respondedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Consultation',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'doctorId': doctorId.toJson(),
      'checkId': checkId.toJson(),
      'status': status.toJson(),
      'doctorNotesKey': doctorNotesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsultationImpl extends Consultation {
  _ConsultationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue doctorId,
    required _i1.UuidValue checkId,
    required _i2.ConsultationStatus status,
    required String doctorNotesKey,
    required String encryptionKey,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) : super._(
         id: id,
         userId: userId,
         doctorId: doctorId,
         checkId: checkId,
         status: status,
         doctorNotesKey: doctorNotesKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
         respondedAt: respondedAt,
       );

  /// Returns a shallow copy of this [Consultation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Consultation copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    _i1.UuidValue? doctorId,
    _i1.UuidValue? checkId,
    _i2.ConsultationStatus? status,
    String? doctorNotesKey,
    String? encryptionKey,
    DateTime? createdAt,
    Object? respondedAt = _Undefined,
  }) {
    return Consultation(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      checkId: checkId ?? this.checkId,
      status: status ?? this.status,
      doctorNotesKey: doctorNotesKey ?? this.doctorNotesKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
    );
  }
}
