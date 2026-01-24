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
import 'enums/severity.dart' as _i2;

abstract class Recommendation implements _i1.SerializableModel {
  Recommendation._({
    _i1.UuidValue? id,
    required this.checkId,
    required this.severity,
    required this.tipsKey,
    required this.warningsKey,
    required this.encryptionKey,
    required this.createdAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Recommendation({
    _i1.UuidValue? id,
    required _i1.UuidValue checkId,
    required _i2.Severity severity,
    required String tipsKey,
    required String warningsKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) = _RecommendationImpl;

  factory Recommendation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recommendation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      severity: _i2.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      tipsKey: jsonSerialization['tipsKey'] as String,
      warningsKey: jsonSerialization['warningsKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i1.UuidValue checkId;

  _i2.Severity severity;

  String tipsKey;

  String warningsKey;

  String encryptionKey;

  DateTime createdAt;

  /// Returns a shallow copy of this [Recommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Recommendation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checkId,
    _i2.Severity? severity,
    String? tipsKey,
    String? warningsKey,
    String? encryptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recommendation',
      'id': id.toJson(),
      'checkId': checkId.toJson(),
      'severity': severity.toJson(),
      'tipsKey': tipsKey,
      'warningsKey': warningsKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RecommendationImpl extends Recommendation {
  _RecommendationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue checkId,
    required _i2.Severity severity,
    required String tipsKey,
    required String warningsKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         checkId: checkId,
         severity: severity,
         tipsKey: tipsKey,
         warningsKey: warningsKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Recommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Recommendation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checkId,
    _i2.Severity? severity,
    String? tipsKey,
    String? warningsKey,
    String? encryptionKey,
    DateTime? createdAt,
  }) {
    return Recommendation(
      id: id ?? this.id,
      checkId: checkId ?? this.checkId,
      severity: severity ?? this.severity,
      tipsKey: tipsKey ?? this.tipsKey,
      warningsKey: warningsKey ?? this.warningsKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
