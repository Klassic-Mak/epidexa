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

abstract class Image implements _i1.SerializableModel {
  Image._({
    _i1.UuidValue? id,
    required this.userId,
    required this.checkId,
    required this.url,
    required this.metadata,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.uploadedAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Image({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue checkId,
    required String url,
    required String metadata,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime uploadedAt,
  }) = _ImageImpl;

  factory Image.fromJson(Map<String, dynamic> jsonSerialization) {
    return Image(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      url: jsonSerialization['url'] as String,
      metadata: jsonSerialization['metadata'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  /// The id of the object.
  _i1.UuidValue id;

  _i1.UuidValue userId;

  _i1.UuidValue checkId;

  String url;

  String metadata;

  String encryptionKey;

  String descriptionKey;

  DateTime uploadedAt;

  /// Returns a shallow copy of this [Image]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Image copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? checkId,
    String? url,
    String? metadata,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Image',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'checkId': checkId.toJson(),
      'url': url,
      'metadata': metadata,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImageImpl extends Image {
  _ImageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue checkId,
    required String url,
    required String metadata,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         userId: userId,
         checkId: checkId,
         url: url,
         metadata: metadata,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [Image]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Image copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? checkId,
    String? url,
    String? metadata,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? uploadedAt,
  }) {
    return Image(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      checkId: checkId ?? this.checkId,
      url: url ?? this.url,
      metadata: metadata ?? this.metadata,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
