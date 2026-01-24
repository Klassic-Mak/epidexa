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
import 'enums/payment_status.dart' as _i2;

abstract class Payment implements _i1.SerializableModel {
  Payment._({
    _i1.UuidValue? id,
    required this.userId,
    required this.consultationId,
    required this.amount,
    required this.status,
    required this.provider,
    required this.transactionId,
    required this.createdAt,
    required this.updatedAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Payment({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue consultationId,
    required double amount,
    required _i2.PaymentStatus status,
    required String provider,
    required String transactionId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PaymentImpl;

  factory Payment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Payment(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      consultationId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['consultationId'],
      ),
      amount: (jsonSerialization['amount'] as num).toDouble(),
      status: _i2.PaymentStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      provider: jsonSerialization['provider'] as String,
      transactionId: jsonSerialization['transactionId'] as String,
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

  _i1.UuidValue consultationId;

  double amount;

  _i2.PaymentStatus status;

  String provider;

  String transactionId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Payment copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? consultationId,
    double? amount,
    _i2.PaymentStatus? status,
    String? provider,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Payment',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'consultationId': consultationId.toJson(),
      'amount': amount,
      'status': status.toJson(),
      'provider': provider,
      'transactionId': transactionId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaymentImpl extends Payment {
  _PaymentImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue consultationId,
    required double amount,
    required _i2.PaymentStatus status,
    required String provider,
    required String transactionId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         consultationId: consultationId,
         amount: amount,
         status: status,
         provider: provider,
         transactionId: transactionId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Payment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Payment copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? consultationId,
    double? amount,
    _i2.PaymentStatus? status,
    String? provider,
    String? transactionId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      consultationId: consultationId ?? this.consultationId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
