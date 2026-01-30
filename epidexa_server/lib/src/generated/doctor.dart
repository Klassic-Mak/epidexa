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

abstract class Doctor
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
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

  static final t = DoctorTable();

  static const db = DoctorRepository._();

  @override
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

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static DoctorInclude include() {
    return DoctorInclude._();
  }

  static DoctorIncludeList includeList({
    _i1.WhereExpressionBuilder<DoctorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoctorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoctorTable>? orderByList,
    DoctorInclude? include,
  }) {
    return DoctorIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Doctor.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Doctor.t),
      include: include,
    );
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

class DoctorUpdateTable extends _i1.UpdateTable<DoctorTable> {
  DoctorUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> credentialsKey(String value) =>
      _i1.ColumnValue(
        table.credentialsKey,
        value,
      );

  _i1.ColumnValue<String, String> encryptionKey(String value) =>
      _i1.ColumnValue(
        table.encryptionKey,
        value,
      );

  _i1.ColumnValue<String, String> licenseNumber(String value) =>
      _i1.ColumnValue(
        table.licenseNumber,
        value,
      );

  _i1.ColumnValue<bool, bool> verified(bool value) => _i1.ColumnValue(
    table.verified,
    value,
  );

  _i1.ColumnValue<double, double> rating(double value) => _i1.ColumnValue(
    table.rating,
    value,
  );

  _i1.ColumnValue<bool, bool> availability(bool value) => _i1.ColumnValue(
    table.availability,
    value,
  );

  _i1.ColumnValue<double, double> fee(double value) => _i1.ColumnValue(
    table.fee,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DoctorTable extends _i1.Table<_i1.UuidValue?> {
  DoctorTable({super.tableRelation}) : super(tableName: 'doctor') {
    updateTable = DoctorUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    credentialsKey = _i1.ColumnString(
      'credentialsKey',
      this,
    );
    encryptionKey = _i1.ColumnString(
      'encryptionKey',
      this,
    );
    licenseNumber = _i1.ColumnString(
      'licenseNumber',
      this,
    );
    verified = _i1.ColumnBool(
      'verified',
      this,
    );
    rating = _i1.ColumnDouble(
      'rating',
      this,
    );
    availability = _i1.ColumnBool(
      'availability',
      this,
    );
    fee = _i1.ColumnDouble(
      'fee',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DoctorUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString credentialsKey;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnString licenseNumber;

  late final _i1.ColumnBool verified;

  late final _i1.ColumnDouble rating;

  late final _i1.ColumnBool availability;

  late final _i1.ColumnDouble fee;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    name,
    credentialsKey,
    encryptionKey,
    licenseNumber,
    verified,
    rating,
    availability,
    fee,
    createdAt,
  ];
}

class DoctorInclude extends _i1.IncludeObject {
  DoctorInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Doctor.t;
}

class DoctorIncludeList extends _i1.IncludeList {
  DoctorIncludeList._({
    _i1.WhereExpressionBuilder<DoctorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Doctor.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Doctor.t;
}

class DoctorRepository {
  const DoctorRepository._();

  /// Returns a list of [Doctor]s matching the given query parameters.
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
  Future<List<Doctor>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoctorTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoctorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoctorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Doctor>(
      where: where?.call(Doctor.t),
      orderBy: orderBy?.call(Doctor.t),
      orderByList: orderByList?.call(Doctor.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Doctor] matching the given query parameters.
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
  Future<Doctor?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoctorTable>? where,
    int? offset,
    _i1.OrderByBuilder<DoctorTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DoctorTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Doctor>(
      where: where?.call(Doctor.t),
      orderBy: orderBy?.call(Doctor.t),
      orderByList: orderByList?.call(Doctor.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Doctor] by its [id] or null if no such row exists.
  Future<Doctor?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Doctor>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Doctor]s in the list and returns the inserted rows.
  ///
  /// The returned [Doctor]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Doctor>> insert(
    _i1.Session session,
    List<Doctor> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Doctor>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Doctor] and returns the inserted row.
  ///
  /// The returned [Doctor] will have its `id` field set.
  Future<Doctor> insertRow(
    _i1.Session session,
    Doctor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Doctor>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Doctor]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Doctor>> update(
    _i1.Session session,
    List<Doctor> rows, {
    _i1.ColumnSelections<DoctorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Doctor>(
      rows,
      columns: columns?.call(Doctor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Doctor]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Doctor> updateRow(
    _i1.Session session,
    Doctor row, {
    _i1.ColumnSelections<DoctorTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Doctor>(
      row,
      columns: columns?.call(Doctor.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Doctor] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Doctor?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<DoctorUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Doctor>(
      id,
      columnValues: columnValues(Doctor.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Doctor]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Doctor>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<DoctorUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DoctorTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DoctorTable>? orderBy,
    _i1.OrderByListBuilder<DoctorTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Doctor>(
      columnValues: columnValues(Doctor.t.updateTable),
      where: where(Doctor.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Doctor.t),
      orderByList: orderByList?.call(Doctor.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Doctor]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Doctor>> delete(
    _i1.Session session,
    List<Doctor> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Doctor>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Doctor].
  Future<Doctor> deleteRow(
    _i1.Session session,
    Doctor row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Doctor>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Doctor>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<DoctorTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Doctor>(
      where: where(Doctor.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<DoctorTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Doctor>(
      where: where?.call(Doctor.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
