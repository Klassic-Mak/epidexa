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

abstract class Consent
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  Consent._({
    this.id,
    required this.userId,
    required this.type,
    required this.accepted,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.createdAt,
  });

  factory Consent({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String type,
    required bool accepted,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) = _ConsentImpl;

  factory Consent.fromJson(Map<String, dynamic> jsonSerialization) {
    return Consent(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      type: jsonSerialization['type'] as String,
      accepted: jsonSerialization['accepted'] as bool,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ConsentTable();

  static const db = ConsentRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  String type;

  bool accepted;

  String encryptionKey;

  String descriptionKey;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Consent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Consent copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    String? type,
    bool? accepted,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Consent',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'type': type,
      'accepted': accepted,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Consent',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'type': type,
      'accepted': accepted,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  static ConsentInclude include() {
    return ConsentInclude._();
  }

  static ConsentIncludeList includeList({
    _i1.WhereExpressionBuilder<ConsentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsentTable>? orderByList,
    ConsentInclude? include,
  }) {
    return ConsentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Consent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Consent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsentImpl extends Consent {
  _ConsentImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required String type,
    required bool accepted,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         type: type,
         accepted: accepted,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Consent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Consent copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    String? type,
    bool? accepted,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? createdAt,
  }) {
    return Consent(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      accepted: accepted ?? this.accepted,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ConsentUpdateTable extends _i1.UpdateTable<ConsentTable> {
  ConsentUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> type(String value) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<bool, bool> accepted(bool value) => _i1.ColumnValue(
    table.accepted,
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

class ConsentTable extends _i1.Table<_i1.UuidValue?> {
  ConsentTable({super.tableRelation}) : super(tableName: 'consent') {
    updateTable = ConsentUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    accepted = _i1.ColumnBool(
      'accepted',
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

  late final ConsentUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnString type;

  late final _i1.ColumnBool accepted;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnString descriptionKey;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    type,
    accepted,
    encryptionKey,
    descriptionKey,
    createdAt,
  ];
}

class ConsentInclude extends _i1.IncludeObject {
  ConsentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Consent.t;
}

class ConsentIncludeList extends _i1.IncludeList {
  ConsentIncludeList._({
    _i1.WhereExpressionBuilder<ConsentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Consent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => Consent.t;
}

class ConsentRepository {
  const ConsentRepository._();

  /// Returns a list of [Consent]s matching the given query parameters.
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
  Future<List<Consent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Consent>(
      where: where?.call(Consent.t),
      orderBy: orderBy?.call(Consent.t),
      orderByList: orderByList?.call(Consent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Consent] matching the given query parameters.
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
  Future<Consent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsentTable>? where,
    int? offset,
    _i1.OrderByBuilder<ConsentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Consent>(
      where: where?.call(Consent.t),
      orderBy: orderBy?.call(Consent.t),
      orderByList: orderByList?.call(Consent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Consent] by its [id] or null if no such row exists.
  Future<Consent?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Consent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Consent]s in the list and returns the inserted rows.
  ///
  /// The returned [Consent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Consent>> insert(
    _i1.Session session,
    List<Consent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Consent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Consent] and returns the inserted row.
  ///
  /// The returned [Consent] will have its `id` field set.
  Future<Consent> insertRow(
    _i1.Session session,
    Consent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Consent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Consent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Consent>> update(
    _i1.Session session,
    List<Consent> rows, {
    _i1.ColumnSelections<ConsentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Consent>(
      rows,
      columns: columns?.call(Consent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Consent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Consent> updateRow(
    _i1.Session session,
    Consent row, {
    _i1.ColumnSelections<ConsentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Consent>(
      row,
      columns: columns?.call(Consent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Consent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Consent?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ConsentUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Consent>(
      id,
      columnValues: columnValues(Consent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Consent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Consent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ConsentUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ConsentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsentTable>? orderBy,
    _i1.OrderByListBuilder<ConsentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Consent>(
      columnValues: columnValues(Consent.t.updateTable),
      where: where(Consent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Consent.t),
      orderByList: orderByList?.call(Consent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Consent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Consent>> delete(
    _i1.Session session,
    List<Consent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Consent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Consent].
  Future<Consent> deleteRow(
    _i1.Session session,
    Consent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Consent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Consent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ConsentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Consent>(
      where: where(Consent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Consent>(
      where: where?.call(Consent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
