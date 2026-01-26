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
import 'enums/symptom.dart' as _i3;
import 'enums/affected_area.dart' as _i4;
import 'enums/severity.dart' as _i5;
import 'package:skinaware_server/src/generated/protocol.dart' as _i6;

abstract class SymptomCheck
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  SymptomCheck._({
    this.id,
    required this.userId,
    required this.skinType,
    required this.symptoms,
    required this.affectedAreas,
    required this.duration,
    required this.severity,
    required this.notesKey,
    required this.encryptionKey,
    required this.createdAt,
  });

  factory SymptomCheck({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    required List<_i3.Symptom> symptoms,
    required List<_i4.AffectedArea> affectedAreas,
    required String duration,
    required _i5.Severity severity,
    required String notesKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) = _SymptomCheckImpl;

  factory SymptomCheck.fromJson(Map<String, dynamic> jsonSerialization) {
    return SymptomCheck(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      skinType: _i2.SkinType.fromJson(
        (jsonSerialization['skinType'] as String),
      ),
      symptoms: _i6.Protocol().deserialize<List<_i3.Symptom>>(
        jsonSerialization['symptoms'],
      ),
      affectedAreas: _i6.Protocol().deserialize<List<_i4.AffectedArea>>(
        jsonSerialization['affectedAreas'],
      ),
      duration: jsonSerialization['duration'] as String,
      severity: _i5.Severity.fromJson(
        (jsonSerialization['severity'] as String),
      ),
      notesKey: jsonSerialization['notesKey'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = SymptomCheckTable();

  static const db = SymptomCheckRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.SkinType skinType;

  List<_i3.Symptom> symptoms;

  List<_i4.AffectedArea> affectedAreas;

  String duration;

  _i5.Severity severity;

  String notesKey;

  String encryptionKey;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SymptomCheck]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SymptomCheck copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    List<_i3.Symptom>? symptoms,
    List<_i4.AffectedArea>? affectedAreas,
    String? duration,
    _i5.Severity? severity,
    String? notesKey,
    String? encryptionKey,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SymptomCheck',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'skinType': skinType.toJson(),
      'symptoms': symptoms.toJson(valueToJson: (v) => v.toJson()),
      'affectedAreas': affectedAreas.toJson(valueToJson: (v) => v.toJson()),
      'duration': duration,
      'severity': severity.toJson(),
      'notesKey': notesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SymptomCheck',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'skinType': skinType.toJson(),
      'symptoms': symptoms.toJson(valueToJson: (v) => v.toJson()),
      'affectedAreas': affectedAreas.toJson(valueToJson: (v) => v.toJson()),
      'duration': duration,
      'severity': severity.toJson(),
      'notesKey': notesKey,
      'encryptionKey': encryptionKey,
      'createdAt': createdAt.toJson(),
    };
  }

  static SymptomCheckInclude include() {
    return SymptomCheckInclude._();
  }

  static SymptomCheckIncludeList includeList({
    _i1.WhereExpressionBuilder<SymptomCheckTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SymptomCheckTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SymptomCheckTable>? orderByList,
    SymptomCheckInclude? include,
  }) {
    return SymptomCheckIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SymptomCheck.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SymptomCheck.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SymptomCheckImpl extends SymptomCheck {
  _SymptomCheckImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i2.SkinType skinType,
    required List<_i3.Symptom> symptoms,
    required List<_i4.AffectedArea> affectedAreas,
    required String duration,
    required _i5.Severity severity,
    required String notesKey,
    required String encryptionKey,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         skinType: skinType,
         symptoms: symptoms,
         affectedAreas: affectedAreas,
         duration: duration,
         severity: severity,
         notesKey: notesKey,
         encryptionKey: encryptionKey,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SymptomCheck]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SymptomCheck copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    _i2.SkinType? skinType,
    List<_i3.Symptom>? symptoms,
    List<_i4.AffectedArea>? affectedAreas,
    String? duration,
    _i5.Severity? severity,
    String? notesKey,
    String? encryptionKey,
    DateTime? createdAt,
  }) {
    return SymptomCheck(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      skinType: skinType ?? this.skinType,
      symptoms: symptoms ?? this.symptoms.map((e0) => e0).toList(),
      affectedAreas:
          affectedAreas ?? this.affectedAreas.map((e0) => e0).toList(),
      duration: duration ?? this.duration,
      severity: severity ?? this.severity,
      notesKey: notesKey ?? this.notesKey,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SymptomCheckUpdateTable extends _i1.UpdateTable<SymptomCheckTable> {
  SymptomCheckUpdateTable(super.table);

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

  _i1.ColumnValue<List<_i3.Symptom>, List<_i3.Symptom>> symptoms(
    List<_i3.Symptom> value,
  ) => _i1.ColumnValue(
    table.symptoms,
    value,
  );

  _i1.ColumnValue<List<_i4.AffectedArea>, List<_i4.AffectedArea>> affectedAreas(
    List<_i4.AffectedArea> value,
  ) => _i1.ColumnValue(
    table.affectedAreas,
    value,
  );

  _i1.ColumnValue<String, String> duration(String value) => _i1.ColumnValue(
    table.duration,
    value,
  );

  _i1.ColumnValue<_i5.Severity, _i5.Severity> severity(_i5.Severity value) =>
      _i1.ColumnValue(
        table.severity,
        value,
      );

  _i1.ColumnValue<String, String> notesKey(String value) => _i1.ColumnValue(
    table.notesKey,
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

class SymptomCheckTable extends _i1.Table<_i1.UuidValue?> {
  SymptomCheckTable({super.tableRelation}) : super(tableName: 'symptom_check') {
    updateTable = SymptomCheckUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    skinType = _i1.ColumnEnum(
      'skinType',
      this,
      _i1.EnumSerialization.byName,
    );
    symptoms = _i1.ColumnSerializable<List<_i3.Symptom>>(
      'symptoms',
      this,
    );
    affectedAreas = _i1.ColumnSerializable<List<_i4.AffectedArea>>(
      'affectedAreas',
      this,
    );
    duration = _i1.ColumnString(
      'duration',
      this,
    );
    severity = _i1.ColumnEnum(
      'severity',
      this,
      _i1.EnumSerialization.byName,
    );
    notesKey = _i1.ColumnString(
      'notesKey',
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

  late final SymptomCheckUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnEnum<_i2.SkinType> skinType;

  late final _i1.ColumnSerializable<List<_i3.Symptom>> symptoms;

  late final _i1.ColumnSerializable<List<_i4.AffectedArea>> affectedAreas;

  late final _i1.ColumnString duration;

  late final _i1.ColumnEnum<_i5.Severity> severity;

  late final _i1.ColumnString notesKey;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    skinType,
    symptoms,
    affectedAreas,
    duration,
    severity,
    notesKey,
    encryptionKey,
    createdAt,
  ];
}

class SymptomCheckInclude extends _i1.IncludeObject {
  SymptomCheckInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SymptomCheck.t;
}

class SymptomCheckIncludeList extends _i1.IncludeList {
  SymptomCheckIncludeList._({
    _i1.WhereExpressionBuilder<SymptomCheckTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SymptomCheck.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => SymptomCheck.t;
}

class SymptomCheckRepository {
  const SymptomCheckRepository._();

  /// Returns a list of [SymptomCheck]s matching the given query parameters.
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
  Future<List<SymptomCheck>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SymptomCheckTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SymptomCheckTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SymptomCheckTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SymptomCheck>(
      where: where?.call(SymptomCheck.t),
      orderBy: orderBy?.call(SymptomCheck.t),
      orderByList: orderByList?.call(SymptomCheck.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SymptomCheck] matching the given query parameters.
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
  Future<SymptomCheck?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SymptomCheckTable>? where,
    int? offset,
    _i1.OrderByBuilder<SymptomCheckTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SymptomCheckTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SymptomCheck>(
      where: where?.call(SymptomCheck.t),
      orderBy: orderBy?.call(SymptomCheck.t),
      orderByList: orderByList?.call(SymptomCheck.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SymptomCheck] by its [id] or null if no such row exists.
  Future<SymptomCheck?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SymptomCheck>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SymptomCheck]s in the list and returns the inserted rows.
  ///
  /// The returned [SymptomCheck]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SymptomCheck>> insert(
    _i1.Session session,
    List<SymptomCheck> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SymptomCheck>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SymptomCheck] and returns the inserted row.
  ///
  /// The returned [SymptomCheck] will have its `id` field set.
  Future<SymptomCheck> insertRow(
    _i1.Session session,
    SymptomCheck row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SymptomCheck>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SymptomCheck]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SymptomCheck>> update(
    _i1.Session session,
    List<SymptomCheck> rows, {
    _i1.ColumnSelections<SymptomCheckTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SymptomCheck>(
      rows,
      columns: columns?.call(SymptomCheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SymptomCheck]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SymptomCheck> updateRow(
    _i1.Session session,
    SymptomCheck row, {
    _i1.ColumnSelections<SymptomCheckTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SymptomCheck>(
      row,
      columns: columns?.call(SymptomCheck.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SymptomCheck] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SymptomCheck?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<SymptomCheckUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SymptomCheck>(
      id,
      columnValues: columnValues(SymptomCheck.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SymptomCheck]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SymptomCheck>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SymptomCheckUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SymptomCheckTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SymptomCheckTable>? orderBy,
    _i1.OrderByListBuilder<SymptomCheckTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SymptomCheck>(
      columnValues: columnValues(SymptomCheck.t.updateTable),
      where: where(SymptomCheck.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SymptomCheck.t),
      orderByList: orderByList?.call(SymptomCheck.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SymptomCheck]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SymptomCheck>> delete(
    _i1.Session session,
    List<SymptomCheck> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SymptomCheck>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SymptomCheck].
  Future<SymptomCheck> deleteRow(
    _i1.Session session,
    SymptomCheck row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SymptomCheck>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SymptomCheck>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SymptomCheckTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SymptomCheck>(
      where: where(SymptomCheck.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SymptomCheckTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SymptomCheck>(
      where: where?.call(SymptomCheck.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
