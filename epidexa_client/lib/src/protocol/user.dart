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
import 'enums/gender.dart' as _i2;
import 'enums/role.dart' as _i3;
import 'enums/skin_type.dart' as _i4;

abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.passwordHash,
    required this.name,
    required this.role,
    required this.skinType,
    this.profilePhoto,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.createdAt,
  });

  factory User({
    _i1.UuidValue? id,
    required String email,
    required String phone,
    required int age,
    required _i2.Gender gender,
    required String passwordHash,
    required String name,
    required _i3.Role role,
    required _i4.SkinType skinType,
    String? profilePhoto,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      phone: jsonSerialization['phone'] as String,
      age: jsonSerialization['age'] as int,
      gender: _i2.Gender.fromJson((jsonSerialization['gender'] as String)),
      passwordHash: jsonSerialization['passwordHash'] as String,
      name: jsonSerialization['name'] as String,
      role: _i3.Role.fromJson((jsonSerialization['role'] as String)),
      skinType: _i4.SkinType.fromJson(
        (jsonSerialization['skinType'] as String),
      ),
      profilePhoto: jsonSerialization['profilePhoto'] as String?,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  String email;

  String phone;

  int age;

  _i2.Gender gender;

  String passwordHash;

  String name;

  _i3.Role role;

  _i4.SkinType skinType;

  String? profilePhoto;

  String encryptionKey;

  String descriptionKey;

  DateTime createdAt;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    _i1.UuidValue? id,
    String? email,
    String? phone,
    int? age,
    _i2.Gender? gender,
    String? passwordHash,
    String? name,
    _i3.Role? role,
    _i4.SkinType? skinType,
    String? profilePhoto,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender.toJson(),
      'passwordHash': passwordHash,
      'name': name,
      'role': role.toJson(),
      'skinType': skinType.toJson(),
      if (profilePhoto != null) 'profilePhoto': profilePhoto,
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

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    _i1.UuidValue? id,
    required String email,
    required String phone,
    required int age,
    required _i2.Gender gender,
    required String passwordHash,
    required String name,
    required _i3.Role role,
    required _i4.SkinType skinType,
    String? profilePhoto,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         phone: phone,
         age: age,
         gender: gender,
         passwordHash: passwordHash,
         name: name,
         role: role,
         skinType: skinType,
         profilePhoto: profilePhoto,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? email,
    String? phone,
    int? age,
    _i2.Gender? gender,
    String? passwordHash,
    String? name,
    _i3.Role? role,
    _i4.SkinType? skinType,
    Object? profilePhoto = _Undefined,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  }) {
    return User(
      id: id is _i1.UuidValue? ? id : this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      role: role ?? this.role,
      skinType: skinType ?? this.skinType,
      profilePhoto: profilePhoto is String? ? profilePhoto : this.profilePhoto,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
