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
import 'package:serverpod/serverpod.dart' as _i1;
import 'enums/skin_type.dart' as _i2;

abstract class UserProfile
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
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

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
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

class UserProfileUpdateTable extends _i1.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i2.SkinType, _i2.SkinType> skinType(_i2.SkinType value) =>
      _i1.ColumnValue(
        table.skinType,
        value,
      );

  _i1.ColumnValue<String, String> skinSensitivity(String? value) =>
      _i1.ColumnValue(
        table.skinSensitivity,
        value,
      );

  _i1.ColumnValue<String, String> oiliness(String? value) => _i1.ColumnValue(
    table.oiliness,
    value,
  );

  _i1.ColumnValue<String, String> skinConcerns(String? value) =>
      _i1.ColumnValue(
        table.skinConcerns,
        value,
      );

  _i1.ColumnValue<String, String> primaryConcern(String? value) =>
      _i1.ColumnValue(
        table.primaryConcern,
        value,
      );

  _i1.ColumnValue<String, String> recommneddation(String? value) =>
      _i1.ColumnValue(
        table.recommneddation,
        value,
      );

  _i1.ColumnValue<String, String> knownAllergies(String? value) =>
      _i1.ColumnValue(
        table.knownAllergies,
        value,
      );

  _i1.ColumnValue<String, String> currentMedications(String? value) =>
      _i1.ColumnValue(
        table.currentMedications,
        value,
      );

  _i1.ColumnValue<String, String> skinConditionHistory(String? value) =>
      _i1.ColumnValue(
        table.skinConditionHistory,
        value,
      );

  _i1.ColumnValue<String, String> sunExposure(String? value) => _i1.ColumnValue(
    table.sunExposure,
    value,
  );

  _i1.ColumnValue<String, String> waterIntake(String? value) => _i1.ColumnValue(
    table.waterIntake,
    value,
  );

  _i1.ColumnValue<String, String> sleepQuality(String? value) =>
      _i1.ColumnValue(
        table.sleepQuality,
        value,
      );

  _i1.ColumnValue<String, String> stressLevel(String? value) => _i1.ColumnValue(
    table.stressLevel,
    value,
  );

  _i1.ColumnValue<String, String> skinGoals(String? value) => _i1.ColumnValue(
    table.skinGoals,
    value,
  );

  _i1.ColumnValue<String, String> preferredLanguage(String? value) =>
      _i1.ColumnValue(
        table.preferredLanguage,
        value,
      );

  _i1.ColumnValue<String, String> productBudget(String? value) =>
      _i1.ColumnValue(
        table.productBudget,
        value,
      );

  _i1.ColumnValue<String, String> routineComplexity(String? value) =>
      _i1.ColumnValue(
        table.routineComplexity,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserProfileTable extends _i1.Table<_i1.UuidValue?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profile') {
    updateTable = UserProfileUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    skinType = _i1.ColumnEnum(
      'skinType',
      this,
      _i1.EnumSerialization.byName,
    );
    skinSensitivity = _i1.ColumnString(
      'skinSensitivity',
      this,
    );
    oiliness = _i1.ColumnString(
      'oiliness',
      this,
    );
    skinConcerns = _i1.ColumnString(
      'skinConcerns',
      this,
    );
    primaryConcern = _i1.ColumnString(
      'primaryConcern',
      this,
    );
    recommneddation = _i1.ColumnString(
      'recommneddation',
      this,
    );
    knownAllergies = _i1.ColumnString(
      'knownAllergies',
      this,
    );
    currentMedications = _i1.ColumnString(
      'currentMedications',
      this,
    );
    skinConditionHistory = _i1.ColumnString(
      'skinConditionHistory',
      this,
    );
    sunExposure = _i1.ColumnString(
      'sunExposure',
      this,
    );
    waterIntake = _i1.ColumnString(
      'waterIntake',
      this,
    );
    sleepQuality = _i1.ColumnString(
      'sleepQuality',
      this,
    );
    stressLevel = _i1.ColumnString(
      'stressLevel',
      this,
    );
    skinGoals = _i1.ColumnString(
      'skinGoals',
      this,
    );
    preferredLanguage = _i1.ColumnString(
      'preferredLanguage',
      this,
    );
    productBudget = _i1.ColumnString(
      'productBudget',
      this,
    );
    routineComplexity = _i1.ColumnString(
      'routineComplexity',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserProfileUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnEnum<_i2.SkinType> skinType;

  late final _i1.ColumnString skinSensitivity;

  late final _i1.ColumnString oiliness;

  late final _i1.ColumnString skinConcerns;

  late final _i1.ColumnString primaryConcern;

  late final _i1.ColumnString recommneddation;

  late final _i1.ColumnString knownAllergies;

  late final _i1.ColumnString currentMedications;

  late final _i1.ColumnString skinConditionHistory;

  late final _i1.ColumnString sunExposure;

  late final _i1.ColumnString waterIntake;

  late final _i1.ColumnString sleepQuality;

  late final _i1.ColumnString stressLevel;

  late final _i1.ColumnString skinGoals;

  late final _i1.ColumnString preferredLanguage;

  late final _i1.ColumnString productBudget;

  late final _i1.ColumnString routineComplexity;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    skinType,
    skinSensitivity,
    oiliness,
    skinConcerns,
    primaryConcern,
    recommneddation,
    knownAllergies,
    currentMedications,
    skinConditionHistory,
    sunExposure,
    waterIntake,
    sleepQuality,
    stressLevel,
    skinGoals,
    preferredLanguage,
    productBudget,
    routineComplexity,
    createdAt,
    updatedAt,
  ];
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
