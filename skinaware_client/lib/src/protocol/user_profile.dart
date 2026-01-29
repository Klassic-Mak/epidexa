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

abstract class UserProfile implements _i1.SerializableModel {
  UserProfile._({
    this.id,
    required this.userId,
    required this.skinType,
    this.skinSensitivity,
    this.oiliness,
    this.skinConcerns,
    this.primaryConcern,
    this.recommneddation,
    this.knownAllergies,
    this.currentMedications,
    this.skinConditionHistory,
    this.sunExposure,
    this.waterIntake,
    this.sleepQuality,
    this.stressLevel,
    this.skinGoals,
    this.preferredLanguage,
    this.productBudget,
    this.routineComplexity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? recommneddation,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      skinType: _i2.SkinType.fromJson(
        (jsonSerialization['skinType'] as String),
      ),
      skinSensitivity: jsonSerialization['skinSensitivity'] as String?,
      oiliness: jsonSerialization['oiliness'] as String?,
      skinConcerns: jsonSerialization['skinConcerns'] as String?,
      primaryConcern: jsonSerialization['primaryConcern'] as String?,
      recommneddation: jsonSerialization['recommneddation'] as String?,
      knownAllergies: jsonSerialization['knownAllergies'] as String?,
      currentMedications: jsonSerialization['currentMedications'] as String?,
      skinConditionHistory:
          jsonSerialization['skinConditionHistory'] as String?,
      sunExposure: jsonSerialization['sunExposure'] as String?,
      waterIntake: jsonSerialization['waterIntake'] as String?,
      sleepQuality: jsonSerialization['sleepQuality'] as String?,
      stressLevel: jsonSerialization['stressLevel'] as String?,
      skinGoals: jsonSerialization['skinGoals'] as String?,
      preferredLanguage: jsonSerialization['preferredLanguage'] as String?,
      productBudget: jsonSerialization['productBudget'] as String?,
      routineComplexity: jsonSerialization['routineComplexity'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.SkinType skinType;

  String? skinSensitivity;

  String? oiliness;

  String? skinConcerns;

  String? primaryConcern;

  String? recommneddation;

  String? knownAllergies;

  String? currentMedications;

  String? skinConditionHistory;

  String? sunExposure;

  String? waterIntake;

  String? sleepQuality;

  String? stressLevel;

  String? skinGoals;

  String? preferredLanguage;

  String? productBudget;

  String? routineComplexity;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? recommneddation,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'skinType': skinType.toJson(),
      if (skinSensitivity != null) 'skinSensitivity': skinSensitivity,
      if (oiliness != null) 'oiliness': oiliness,
      if (skinConcerns != null) 'skinConcerns': skinConcerns,
      if (primaryConcern != null) 'primaryConcern': primaryConcern,
      if (recommneddation != null) 'recommneddation': recommneddation,
      if (knownAllergies != null) 'knownAllergies': knownAllergies,
      if (currentMedications != null) 'currentMedications': currentMedications,
      if (skinConditionHistory != null)
        'skinConditionHistory': skinConditionHistory,
      if (sunExposure != null) 'sunExposure': sunExposure,
      if (waterIntake != null) 'waterIntake': waterIntake,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (stressLevel != null) 'stressLevel': stressLevel,
      if (skinGoals != null) 'skinGoals': skinGoals,
      if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
      if (productBudget != null) 'productBudget': productBudget,
      if (routineComplexity != null) 'routineComplexity': routineComplexity,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? recommneddation,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         skinType: skinType,
         skinSensitivity: skinSensitivity,
         oiliness: oiliness,
         skinConcerns: skinConcerns,
         primaryConcern: primaryConcern,
         recommneddation: recommneddation,
         knownAllergies: knownAllergies,
         currentMedications: currentMedications,
         skinConditionHistory: skinConditionHistory,
         sunExposure: sunExposure,
         waterIntake: waterIntake,
         sleepQuality: sleepQuality,
         stressLevel: stressLevel,
         skinGoals: skinGoals,
         preferredLanguage: preferredLanguage,
         productBudget: productBudget,
         routineComplexity: routineComplexity,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    Object? skinSensitivity = _Undefined,
    Object? oiliness = _Undefined,
    Object? skinConcerns = _Undefined,
    Object? primaryConcern = _Undefined,
    Object? recommneddation = _Undefined,
    Object? knownAllergies = _Undefined,
    Object? currentMedications = _Undefined,
    Object? skinConditionHistory = _Undefined,
    Object? sunExposure = _Undefined,
    Object? waterIntake = _Undefined,
    Object? sleepQuality = _Undefined,
    Object? stressLevel = _Undefined,
    Object? skinGoals = _Undefined,
    Object? preferredLanguage = _Undefined,
    Object? productBudget = _Undefined,
    Object? routineComplexity = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      skinType: skinType ?? this.skinType,
      skinSensitivity: skinSensitivity is String?
          ? skinSensitivity
          : this.skinSensitivity,
      oiliness: oiliness is String? ? oiliness : this.oiliness,
      skinConcerns: skinConcerns is String? ? skinConcerns : this.skinConcerns,
      primaryConcern: primaryConcern is String?
          ? primaryConcern
          : this.primaryConcern,
      recommneddation: recommneddation is String?
          ? recommneddation
          : this.recommneddation,
      knownAllergies: knownAllergies is String?
          ? knownAllergies
          : this.knownAllergies,
      currentMedications: currentMedications is String?
          ? currentMedications
          : this.currentMedications,
      skinConditionHistory: skinConditionHistory is String?
          ? skinConditionHistory
          : this.skinConditionHistory,
      sunExposure: sunExposure is String? ? sunExposure : this.sunExposure,
      waterIntake: waterIntake is String? ? waterIntake : this.waterIntake,
      sleepQuality: sleepQuality is String? ? sleepQuality : this.sleepQuality,
      stressLevel: stressLevel is String? ? stressLevel : this.stressLevel,
      skinGoals: skinGoals is String? ? skinGoals : this.skinGoals,
      preferredLanguage: preferredLanguage is String?
          ? preferredLanguage
          : this.preferredLanguage,
      productBudget: productBudget is String?
          ? productBudget
          : this.productBudget,
      routineComplexity: routineComplexity is String?
          ? routineComplexity
          : this.routineComplexity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
