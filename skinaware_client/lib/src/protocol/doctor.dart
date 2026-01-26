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

abstract class Doctor implements _i1.SerializableModel {
  Doctor._({
    this.id,
    required this.userId,
    required this.name,
    required this.credentialsKey,
    required this.encryptionKey,
    required this.licenseNumber,
    required this.verified,
    required this.rating,
    required this.availability,
    required this.fee,
    required this.createdAt,
  });

  factory Doctor({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String name,
    required String credentialsKey,
    required String encryptionKey,
    required String licenseNumber,
    required bool verified,
    required double rating,
    required bool availability,
    required double fee,
    required DateTime createdAt,
  }) = _DoctorImpl;

  factory Doctor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Doctor(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      credentialsKey: jsonSerialization['credentialsKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      licenseNumber: jsonSerialization['licenseNumber'] as String,
      verified: jsonSerialization['verified'] as bool,
      rating: (jsonSerialization['rating'] as num).toDouble(),
      availability: jsonSerialization['availability'] as bool,
      fee: (jsonSerialization['fee'] as num).toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String name;

  String credentialsKey;

  String encryptionKey;

  String licenseNumber;

  bool verified;

  double rating;

  bool availability;

  double fee;

  DateTime createdAt;

  /// Returns a shallow copy of this [Doctor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Doctor copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? name,
    String? credentialsKey,
    String? encryptionKey,
    String? licenseNumber,
    bool? verified,
    double? rating,
    bool? availability,
    double? fee,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Doctor',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'name': name,
      'credentialsKey': credentialsKey,
      'encryptionKey': encryptionKey,
      'licenseNumber': licenseNumber,
      'verified': verified,
      'rating': rating,
      'availability': availability,
      'fee': fee,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoctorImpl extends Doctor {
  _DoctorImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String name,
    required String credentialsKey,
    required String encryptionKey,
    required String licenseNumber,
    required bool verified,
    required double rating,
    required bool availability,
    required double fee,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         credentialsKey: credentialsKey,
         encryptionKey: encryptionKey,
         licenseNumber: licenseNumber,
         verified: verified,
         rating: rating,
         availability: availability,
         fee: fee,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Doctor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Doctor copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? name,
    String? credentialsKey,
    String? encryptionKey,
    String? licenseNumber,
    bool? verified,
    double? rating,
    bool? availability,
    double? fee,
    DateTime? createdAt,
  }) {
    return Doctor(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      credentialsKey: credentialsKey ?? this.credentialsKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      verified: verified ?? this.verified,
      rating: rating ?? this.rating,
      availability: availability ?? this.availability,
      fee: fee ?? this.fee,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
