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
import 'enums/skin_type.dart' as _i2;
import 'enums/symptom.dart' as _i3;
import 'enums/affected_area.dart' as _i4;
import 'enums/severity.dart' as _i5;
import 'package:skinaware_client/src/protocol/protocol.dart' as _i6;

abstract class SymptomCheck implements _i1.SerializableModel {
  SymptomCheck._({
    _i1.UuidValue? id,
    required this.userId,
    required this.skinType,
    required this.symptoms,
    required this.affectedAreas,
    required this.duration,
    required this.severity,
    required this.notesKey,
    required this.encryptionKey,
    required this.createdAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory SymptomCheck({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    required List<_i3.Symptom> symptoms,
    required List<_i4.AffectedArea> affectedAreas,
    required String duration,
    required _i5.Severity severity,
    required String notesKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) = _SymptomCheckImpl;

  factory SymptomCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SymptomCheck(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      skinType: _i2.SkinType.fromJson(
        (jsonSerialization['skinType'] as String),
      ),
      symptoms: _i6.Protocol().deserialize<List<_i3.Symptom>>(
        jsonSerialization['symptoms'],
      ),
      affectedAreas: _i6.Protocol().deserialize<List<_i4.AffectedArea>>(
        jsonSerialization['affectedAreas'],
      ),
      duration: jsonSerialization['duration'] as String,
      severity: _i5.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      notesKey: jsonSerialization['notesKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i1.UuidValue userId;

  _i2.SkinType skinType;

  List<_i3.Symptom> symptoms;

  List<_i4.AffectedArea> affectedAreas;

  String duration;

  _i5.Severity severity;

  String notesKey;

  String encryptionKey;

  DateTime createdAt;

  /// Returns a shallow copy of this [SymptomCheck]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SymptomCheck copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    List<_i3.Symptom>? symptoms,
    List<_i4.AffectedArea>? affectedAreas,
    String? duration,
    _i5.Severity? severity,
    String? notesKey,
    String? encryptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SymptomCheck',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'skinType': skinType.toJson(),
      'symptoms': symptoms.toJson(valueToJson: (v) => v.toJson()),
      'affectedAreas': affectedAreas.toJson(valueToJson: (v) => v.toJson()),
      'duration': duration,
      'severity': severity.toJson(),
      'notesKey': notesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SymptomCheckImpl extends SymptomCheck {
  _SymptomCheckImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    required List<_i3.Symptom> symptoms,
    required List<_i4.AffectedArea> affectedAreas,
    required String duration,
    required _i5.Severity severity,
    required String notesKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         skinType: skinType,
         symptoms: symptoms,
         affectedAreas: affectedAreas,
         duration: duration,
         severity: severity,
         notesKey: notesKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SymptomCheck]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SymptomCheck copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    List<_i3.Symptom>? symptoms,
    List<_i4.AffectedArea>? affectedAreas,
    String? duration,
    _i5.Severity? severity,
    String? notesKey,
    String? encryptionKey,
    DateTime? createdAt,
  }) {
    return SymptomCheck(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      skinType: skinType ?? this.skinType,
      symptoms: symptoms ?? this.symptoms.map((e0) => e0).toList(),
      affectedAreas:
          affectedAreas ?? this.affectedAreas.map((e0) => e0).toList(),
      duration: duration ?? this.duration,
      severity: severity ?? this.severity,
      notesKey: notesKey ?? this.notesKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
