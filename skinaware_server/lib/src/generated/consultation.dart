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
import 'enums/consultation_status.dart' as _i2;

abstract class Consultation
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Consultation._({
    _i1.UuidValue? id,
    required this.userId,
    required this.doctorId,
    required this.checkId,
    required this.status,
    required this.doctorNotesKey,
    required this.encryptionKey,
    required this.createdAt,
    this.respondedAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Consultation({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue doctorId,
    required _i1.UuidValue checkId,
    required _i2.ConsultationStatus status,
    required String doctorNotesKey,
    required String encryptionKey,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) = _ConsultationImpl;

  factory Consultation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Consultation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      doctorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['doctorId'],
      ),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      status: _i2.ConsultationStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      doctorNotesKey: jsonSerialization['doctorNotesKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      respondedAt: jsonSerialization['respondedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['respondedAt'],
            ),
    );
  }

  static final t = ConsultationTable();

  static const db = ConsultationRepository._();

  @override
  _i1.UuidValue id;

  _i1.UuidValue userId;

  _i1.UuidValue doctorId;

  _i1.UuidValue checkId;

  _i2.ConsultationStatus status;

  String doctorNotesKey;

  String encryptionKey;

  DateTime createdAt;

  DateTime? respondedAt;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Consultation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Consultation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? doctorId,
    _i1.UuidValue? checkId,
    _i2.ConsultationStatus? status,
    String? doctorNotesKey,
    String? encryptionKey,
    DateTime? createdAt,
    DateTime? respondedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Consultation',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'doctorId': doctorId.toJson(),
      'checkId': checkId.toJson(),
      'status': status.toJson(),
      'doctorNotesKey': doctorNotesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Consultation',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'doctorId': doctorId.toJson(),
      'checkId': checkId.toJson(),
      'status': status.toJson(),
      'doctorNotesKey': doctorNotesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
      if (respondedAt != null) 'respondedAt': respondedAt?.toJson(),
    };
  }

  static ConsultationInclude include() {
    return ConsultationInclude._();
  }

  static ConsultationIncludeList includeList({
    _i1.WhereExpressionBuilder<ConsultationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsultationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsultationTable>? orderByList,
    ConsultationInclude? include,
  }) {
    return ConsultationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Consultation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Consultation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsultationImpl extends Consultation {
  _ConsultationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue doctorId,
    required _i1.UuidValue checkId,
    required _i2.ConsultationStatus status,
    required String doctorNotesKey,
    required String encryptionKey,
    required DateTime createdAt,
    DateTime? respondedAt,
  }) : super._(
         id: id,
         userId: userId,
         doctorId: doctorId,
         checkId: checkId,
         status: status,
         doctorNotesKey: doctorNotesKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
         respondedAt: respondedAt,
       );

  /// Returns a shallow copy of this [Consultation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Consultation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? doctorId,
    _i1.UuidValue? checkId,
    _i2.ConsultationStatus? status,
    String? doctorNotesKey,
    String? encryptionKey,
    DateTime? createdAt,
    Object? respondedAt = _Undefined,
  }) {
    return Consultation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      checkId: checkId ?? this.checkId,
      status: status ?? this.status,
      doctorNotesKey: doctorNotesKey ?? this.doctorNotesKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt is DateTime? ? respondedAt : this.respondedAt,
    );
  }
}

class ConsultationUpdateTable extends _i1.UpdateTable<ConsultationTable> {
  ConsultationUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> doctorId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.doctorId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> checkId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.checkId,
        value,
      );

  _i1.ColumnValue<_i2.ConsultationStatus, _i2.ConsultationStatus> status(
    _i2.ConsultationStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> doctorNotesKey(String value) =>
      _i1.ColumnValue(
        table.doctorNotesKey,
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

  _i1.ColumnValue<DateTime, DateTime> respondedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.respondedAt,
        value,
      );
}

class ConsultationTable extends _i1.Table<_i1.UuidValue> {
  ConsultationTable({super.tableRelation}) : super(tableName: 'consultation') {
    updateTable = ConsultationUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    doctorId = _i1.ColumnUuid(
      'doctorId',
      this,
    );
    checkId = _i1.ColumnUuid(
      'checkId',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
    );
    doctorNotesKey = _i1.ColumnString(
      'doctorNotesKey',
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
    respondedAt = _i1.ColumnDateTime(
      'respondedAt',
      this,
    );
  }

  late final ConsultationUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnUuid doctorId;

  late final _i1.ColumnUuid checkId;

  late final _i1.ColumnEnum<_i2.ConsultationStatus> status;

  late final _i1.ColumnString doctorNotesKey;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime respondedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    doctorId,
    checkId,
    status,
    doctorNotesKey,
    encryptionKey,
    createdAt,
    respondedAt,
  ];
}

class ConsultationInclude extends _i1.IncludeObject {
  ConsultationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue> get table => Consultation.t;
}

class ConsultationIncludeList extends _i1.IncludeList {
  ConsultationIncludeList._({
    _i1.WhereExpressionBuilder<ConsultationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Consultation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Consultation.t;
}

class ConsultationRepository {
  const ConsultationRepository._();

  /// Returns a list of [Consultation]s matching the given query parameters.
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
  Future<List<Consultation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsultationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsultationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsultationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Consultation>(
      where: where?.call(Consultation.t),
      orderBy: orderBy?.call(Consultation.t),
      orderByList: orderByList?.call(Consultation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Consultation] matching the given query parameters.
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
  Future<Consultation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsultationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ConsultationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ConsultationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Consultation>(
      where: where?.call(Consultation.t),
      orderBy: orderBy?.call(Consultation.t),
      orderByList: orderByList?.call(Consultation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Consultation] by its [id] or null if no such row exists.
  Future<Consultation?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Consultation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Consultation]s in the list and returns the inserted rows.
  ///
  /// The returned [Consultation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Consultation>> insert(
    _i1.Session session,
    List<Consultation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Consultation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Consultation] and returns the inserted row.
  ///
  /// The returned [Consultation] will have its `id` field set.
  Future<Consultation> insertRow(
    _i1.Session session,
    Consultation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Consultation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Consultation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Consultation>> update(
    _i1.Session session,
    List<Consultation> rows, {
    _i1.ColumnSelections<ConsultationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Consultation>(
      rows,
      columns: columns?.call(Consultation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Consultation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Consultation> updateRow(
    _i1.Session session,
    Consultation row, {
    _i1.ColumnSelections<ConsultationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Consultation>(
      row,
      columns: columns?.call(Consultation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Consultation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Consultation?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ConsultationUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Consultation>(
      id,
      columnValues: columnValues(Consultation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Consultation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Consultation>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ConsultationUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ConsultationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ConsultationTable>? orderBy,
    _i1.OrderByListBuilder<ConsultationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Consultation>(
      columnValues: columnValues(Consultation.t.updateTable),
      where: where(Consultation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Consultation.t),
      orderByList: orderByList?.call(Consultation.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Consultation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Consultation>> delete(
    _i1.Session session,
    List<Consultation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Consultation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Consultation].
  Future<Consultation> deleteRow(
    _i1.Session session,
    Consultation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Consultation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Consultation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ConsultationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Consultation>(
      where: where(Consultation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ConsultationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Consultation>(
      where: where?.call(Consultation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
