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
import 'sender_type.dart' as _i2;

abstract class Message implements _i1.SerializableModel {
  Message._({
    this.id,
    required this.consultationId,
    required this.senderId,
    required this.senderType,
    required this.messageKey,
    required this.encryptionKey,
    required this.createdAt,
  });

  factory Message({
    _i1.UuidValue? id,
    required _i1.UuidValue consultationId,
    required _i1.UuidValue senderId,
    required _i2.SenderType senderType,
    required String messageKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) = _MessageImpl;

  factory Message.fromJson(Map<String, dynamic> jsonSerialization) {
    return Message(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      consultationId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['consultationId'],
      ),
      senderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['senderId'],
      ),
      senderType: _i2.SenderType.fromJson(
        (jsonSerialization['senderType'] as String),
      ),
      messageKey: jsonSerialization['messageKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue consultationId;

  _i1.UuidValue senderId;

  _i2.SenderType senderType;

  String messageKey;

  String encryptionKey;

  DateTime createdAt;

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Message copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? consultationId,
    _i1.UuidValue? senderId,
    _i2.SenderType? senderType,
    String? messageKey,
    String? encryptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Message',
      if (id != null) 'id': id?.toJson(),
      'consultationId': consultationId.toJson(),
      'senderId': senderId.toJson(),
      'senderType': senderType.toJson(),
      'messageKey': messageKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MessageImpl extends Message {
  _MessageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue consultationId,
    required _i1.UuidValue senderId,
    required _i2.SenderType senderType,
    required String messageKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         consultationId: consultationId,
         senderId: senderId,
         senderType: senderType,
         messageKey: messageKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Message]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Message copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? consultationId,
    _i1.UuidValue? senderId,
    _i2.SenderType? senderType,
    String? messageKey,
    String? encryptionKey,
    DateTime? createdAt,
  }) {
    return Message(
      id: id is _i1.UuidValue? ? id : this.id,
      consultationId: consultationId ?? this.consultationId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      messageKey: messageKey ?? this.messageKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
