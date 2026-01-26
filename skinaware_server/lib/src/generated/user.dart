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
import 'enums/gender.dart' as _i2;
import 'enums/role.dart' as _i3;
import 'enums/skin_type.dart' as _i4;

abstract class User
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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

  static final t = UserTable();

  static const db = UserRepository._();

  @override
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

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static UserInclude include() {
    return UserInclude._();
  }

  static UserIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    UserInclude? include,
  }) {
    return UserIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(User.t),
      include: include,
    );
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

class UserUpdateTable extends _i1.UpdateTable<UserTable> {
  UserUpdateTable(super.table);

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> phone(String value) => _i1.ColumnValue(
    table.phone,
    value,
  );

  _i1.ColumnValue<int, int> age(int value) => _i1.ColumnValue(
    table.age,
    value,
  );

  _i1.ColumnValue<_i2.Gender, _i2.Gender> gender(_i2.Gender value) =>
      _i1.ColumnValue(
        table.gender,
        value,
      );

  _i1.ColumnValue<String, String> passwordHash(String value) => _i1.ColumnValue(
    table.passwordHash,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<_i3.Role, _i3.Role> role(_i3.Role value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<_i4.SkinType, _i4.SkinType> skinType(_i4.SkinType value) =>
      _i1.ColumnValue(
        table.skinType,
        value,
      );

  _i1.ColumnValue<String, String> profilePhoto(String? value) =>
      _i1.ColumnValue(
        table.profilePhoto,
        value,
      );

  _i1.ColumnValue<String, String> encryptionKey(String value) =>
      _i1.ColumnValue(
        table.encryptionKey,
        value,
      );

  _i1.ColumnValue<String, String> descriptionKey(String value) =>
      _i1.ColumnValue(
        table.descriptionKey,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class UserTable extends _i1.Table<_i1.UuidValue?> {
  UserTable({super.tableRelation}) : super(tableName: 'app_user') {
    updateTable = UserUpdateTable(this);
    email = _i1.ColumnString(
      'email',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    age = _i1.ColumnInt(
      'age',
      this,
    );
    gender = _i1.ColumnEnum(
      'gender',
      this,
      _i1.EnumSerialization.byName,
    );
    passwordHash = _i1.ColumnString(
      'passwordHash',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byName,
    );
    skinType = _i1.ColumnEnum(
      'skinType',
      this,
      _i1.EnumSerialization.byName,
    );
    profilePhoto = _i1.ColumnString(
      'profilePhoto',
      this,
    );
    encryptionKey = _i1.ColumnString(
      'encryptionKey',
      this,
    );
    descriptionKey = _i1.ColumnString(
      'descriptionKey',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final UserUpdateTable updateTable;

  late final _i1.ColumnString email;

  late final _i1.ColumnString phone;

  late final _i1.ColumnInt age;

  late final _i1.ColumnEnum<_i2.Gender> gender;

  late final _i1.ColumnString passwordHash;

  late final _i1.ColumnString name;

  late final _i1.ColumnEnum<_i3.Role> role;

  late final _i1.ColumnEnum<_i4.SkinType> skinType;

  late final _i1.ColumnString profilePhoto;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnString descriptionKey;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    email,
    phone,
    age,
    gender,
    passwordHash,
    name,
    role,
    skinType,
    profilePhoto,
    encryptionKey,
    descriptionKey,
    createdAt,
  ];
}

class UserInclude extends _i1.IncludeObject {
  UserInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => User.t;
}

class UserIncludeList extends _i1.IncludeList {
  UserIncludeList._({
    _i1.WhereExpressionBuilder<UserTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(User.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => User.t;
}

class UserRepository {
  const UserRepository._();

  /// Returns a list of [User]s matching the given query parameters.
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
  Future<List<User>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [User] matching the given query parameters.
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
  Future<User?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<User>(
      where: where?.call(User.t),
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [User] by its [id] or null if no such row exists.
  Future<User?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<User>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [User]s in the list and returns the inserted rows.
  ///
  /// The returned [User]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<User>> insert(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [User] and returns the inserted row.
  ///
  /// The returned [User] will have its `id` field set.
  Future<User> insertRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [User]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<User>> update(
    _i1.Session session,
    List<User> rows, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<User>(
      rows,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<User> updateRow(
    _i1.Session session,
    User row, {
    _i1.ColumnSelections<UserTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<User>(
      row,
      columns: columns?.call(User.t),
      transaction: transaction,
    );
  }

  /// Updates a single [User] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<User?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<User>(
      id,
      columnValues: columnValues(User.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [User]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<User>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTable>? orderBy,
    _i1.OrderByListBuilder<UserTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<User>(
      columnValues: columnValues(User.t.updateTable),
      where: where(User.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(User.t),
      orderByList: orderByList?.call(User.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [User]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<User>> delete(
    _i1.Session session,
    List<User> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<User>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [User].
  Future<User> deleteRow(
    _i1.Session session,
    User row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<User>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<User>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<User>(
      where: where(User.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<User>(
      where: where?.call(User.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
