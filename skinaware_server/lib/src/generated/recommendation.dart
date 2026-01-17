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
import 'enums/severity.dart' as _i2;

abstract class Recommendation
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Recommendation._({
    _i1.UuidValue? id,
    required this.checkId,
    required this.severity,
    required this.tipsKey,
    required this.warningsKey,
    required this.encryptionKey,
    required this.createdAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Recommendation({
    _i1.UuidValue? id,
    required _i1.UuidValue checkId,
    required _i2.Severity severity,
    required String tipsKey,
    required String warningsKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) = _RecommendationImpl;

  factory Recommendation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Recommendation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      severity: _i2.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      tipsKey: jsonSerialization['tipsKey'] as String,
      warningsKey: jsonSerialization['warningsKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = RecommendationTable();

  static const db = RecommendationRepository._();

  @override
  _i1.UuidValue id;

  _i1.UuidValue checkId;

  _i2.Severity severity;

  String tipsKey;

  String warningsKey;

  String encryptionKey;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Recommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Recommendation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checkId,
    _i2.Severity? severity,
    String? tipsKey,
    String? warningsKey,
    String? encryptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Recommendation',
      'id': id.toJson(),
      'checkId': checkId.toJson(),
      'severity': severity.toJson(),
      'tipsKey': tipsKey,
      'warningsKey': warningsKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Recommendation',
      'id': id.toJson(),
      'checkId': checkId.toJson(),
      'severity': severity.toJson(),
      'tipsKey': tipsKey,
      'warningsKey': warningsKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  static RecommendationInclude include() {
    return RecommendationInclude._();
  }

  static RecommendationIncludeList includeList({
    _i1.WhereExpressionBuilder<RecommendationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecommendationTable>? orderByList,
    RecommendationInclude? include,
  }) {
    return RecommendationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recommendation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Recommendation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RecommendationImpl extends Recommendation {
  _RecommendationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue checkId,
    required _i2.Severity severity,
    required String tipsKey,
    required String warningsKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         checkId: checkId,
         severity: severity,
         tipsKey: tipsKey,
         warningsKey: warningsKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Recommendation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Recommendation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? checkId,
    _i2.Severity? severity,
    String? tipsKey,
    String? warningsKey,
    String? encryptionKey,
    DateTime? createdAt,
  }) {
    return Recommendation(
      id: id ?? this.id,
      checkId: checkId ?? this.checkId,
      severity: severity ?? this.severity,
      tipsKey: tipsKey ?? this.tipsKey,
      warningsKey: warningsKey ?? this.warningsKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RecommendationUpdateTable extends _i1.UpdateTable<RecommendationTable> {
  RecommendationUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> checkId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.checkId,
        value,
      );

  _i1.ColumnValue<_i2.Severity, _i2.Severity> severity(_i2.Severity value) =>
      _i1.ColumnValue(
        table.severity,
        value,
      );

  _i1.ColumnValue<String, String> tipsKey(String value) => _i1.ColumnValue(
    table.tipsKey,
    value,
  );

  _i1.ColumnValue<String, String> warningsKey(String value) => _i1.ColumnValue(
    table.warningsKey,
    value,
  );

  _i1.ColumnValue<String, String> encryptionKey(String value) =>
      _i1.ColumnValue(
        table.encryptionKey,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class RecommendationTable extends _i1.Table<_i1.UuidValue> {
  RecommendationTable({super.tableRelation})
    : super(tableName: 'recommendation') {
    updateTable = RecommendationUpdateTable(this);
    checkId = _i1.ColumnUuid(
      'checkId',
      this,
    );
    severity = _i1.ColumnEnum(
      'severity',
      this,
      _i1.EnumSerialization.byName,
    );
    tipsKey = _i1.ColumnString(
      'tipsKey',
      this,
    );
    warningsKey = _i1.ColumnString(
      'warningsKey',
      this,
    );
    encryptionKey = _i1.ColumnString(
      'encryptionKey',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final RecommendationUpdateTable updateTable;

  late final _i1.ColumnUuid checkId;

  late final _i1.ColumnEnum<_i2.Severity> severity;

  late final _i1.ColumnString tipsKey;

  late final _i1.ColumnString warningsKey;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    checkId,
    severity,
    tipsKey,
    warningsKey,
    encryptionKey,
    createdAt,
  ];
}

class RecommendationInclude extends _i1.IncludeObject {
  RecommendationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue> get table => Recommendation.t;
}

class RecommendationIncludeList extends _i1.IncludeList {
  RecommendationIncludeList._({
    _i1.WhereExpressionBuilder<RecommendationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Recommendation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Recommendation.t;
}

class RecommendationRepository {
  const RecommendationRepository._();

  /// Returns a list of [Recommendation]s matching the given query parameters.
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
  Future<List<Recommendation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecommendationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecommendationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Recommendation>(
      where: where?.call(Recommendation.t),
      orderBy: orderBy?.call(Recommendation.t),
      orderByList: orderByList?.call(Recommendation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Recommendation] matching the given query parameters.
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
  Future<Recommendation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecommendationTable>? where,
    int? offset,
    _i1.OrderByBuilder<RecommendationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RecommendationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Recommendation>(
      where: where?.call(Recommendation.t),
      orderBy: orderBy?.call(Recommendation.t),
      orderByList: orderByList?.call(Recommendation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Recommendation] by its [id] or null if no such row exists.
  Future<Recommendation?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Recommendation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Recommendation]s in the list and returns the inserted rows.
  ///
  /// The returned [Recommendation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Recommendation>> insert(
    _i1.Session session,
    List<Recommendation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Recommendation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Recommendation] and returns the inserted row.
  ///
  /// The returned [Recommendation] will have its `id` field set.
  Future<Recommendation> insertRow(
    _i1.Session session,
    Recommendation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Recommendation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Recommendation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Recommendation>> update(
    _i1.Session session,
    List<Recommendation> rows, {
    _i1.ColumnSelections<RecommendationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Recommendation>(
      rows,
      columns: columns?.call(Recommendation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Recommendation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Recommendation> updateRow(
    _i1.Session session,
    Recommendation row, {
    _i1.ColumnSelections<RecommendationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Recommendation>(
      row,
      columns: columns?.call(Recommendation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Recommendation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Recommendation?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<RecommendationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Recommendation>(
      id,
      columnValues: columnValues(Recommendation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Recommendation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Recommendation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<RecommendationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RecommendationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RecommendationTable>? orderBy,
    _i1.OrderByListBuilder<RecommendationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Recommendation>(
      columnValues: columnValues(Recommendation.t.updateTable),
      where: where(Recommendation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Recommendation.t),
      orderByList: orderByList?.call(Recommendation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Recommendation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Recommendation>> delete(
    _i1.Session session,
    List<Recommendation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Recommendation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Recommendation].
  Future<Recommendation> deleteRow(
    _i1.Session session,
    Recommendation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Recommendation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Recommendation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<RecommendationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Recommendation>(
      where: where(Recommendation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<RecommendationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Recommendation>(
      where: where?.call(Recommendation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
