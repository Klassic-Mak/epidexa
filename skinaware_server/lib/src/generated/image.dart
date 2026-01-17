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

abstract class Image
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Image._({
    _i1.UuidValue? id,
    required this.userId,
    required this.checkId,
    required this.url,
    required this.metadata,
    required this.encryptionKey,
    required this.descriptionKey,
    required this.uploadedAt,
  }) : id = id ?? _i1.Uuid().v7obj();

  factory Image({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue checkId,
    required String url,
    required String metadata,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime uploadedAt,
  }) = _ImageImpl;

  factory Image.fromJson(Map<String, dynamic> jsonSerialization) {
    return Image(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      checkId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['checkId'],
      ),
      url: jsonSerialization['url'] as String,
      metadata: jsonSerialization['metadata'] as String,
      encryptionKey: jsonSerialization['encryptionKey'] as String,
      descriptionKey: jsonSerialization['descriptionKey'] as String,
      uploadedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['uploadedAt'],
      ),
    );
  }

  static final t = ImageTable();

  static const db = ImageRepository._();

  @override
  _i1.UuidValue id;

  _i1.UuidValue userId;

  _i1.UuidValue checkId;

  String url;

  String metadata;

  String encryptionKey;

  String descriptionKey;

  DateTime uploadedAt;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Image]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Image copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? checkId,
    String? url,
    String? metadata,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? uploadedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Image',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'checkId': checkId.toJson(),
      'url': url,
      'metadata': metadata,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Image',
      'id': id.toJson(),
      'userId': userId.toJson(),
      'checkId': checkId.toJson(),
      'url': url,
      'metadata': metadata,
      'encryptionKey': encryptionKey,
      'descriptionKey': descriptionKey,
      'uploadedAt': uploadedAt.toJson(),
    };
  }

  static ImageInclude include() {
    return ImageInclude._();
  }

  static ImageIncludeList includeList({
    _i1.WhereExpressionBuilder<ImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImageTable>? orderByList,
    ImageInclude? include,
  }) {
    return ImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Image.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Image.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImageImpl extends Image {
  _ImageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required _i1.UuidValue checkId,
    required String url,
    required String metadata,
    required String encryptionKey,
    required String descriptionKey,
    required DateTime uploadedAt,
  }) : super._(
         id: id,
         userId: userId,
         checkId: checkId,
         url: url,
         metadata: metadata,
         encryptionKey: encryptionKey,
         descriptionKey: descriptionKey,
         uploadedAt: uploadedAt,
       );

  /// Returns a shallow copy of this [Image]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Image copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i1.UuidValue? checkId,
    String? url,
    String? metadata,
    String? encryptionKey,
    String? descriptionKey,
    DateTime? uploadedAt,
  }) {
    return Image(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      checkId: checkId ?? this.checkId,
      url: url ?? this.url,
      metadata: metadata ?? this.metadata,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

class ImageUpdateTable extends _i1.UpdateTable<ImageTable> {
  ImageUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> checkId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.checkId,
        value,
      );

  _i1.ColumnValue<String, String> url(String value) => _i1.ColumnValue(
    table.url,
    value,
  );

  _i1.ColumnValue<String, String> metadata(String value) => _i1.ColumnValue(
    table.metadata,
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

  _i1.ColumnValue<DateTime, DateTime> uploadedAt(DateTime value) =>
      _i1.ColumnValue(
        table.uploadedAt,
        value,
      );
}

class ImageTable extends _i1.Table<_i1.UuidValue> {
  ImageTable({super.tableRelation}) : super(tableName: 'image') {
    updateTable = ImageUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    checkId = _i1.ColumnUuid(
      'checkId',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
    metadata = _i1.ColumnString(
      'metadata',
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
    uploadedAt = _i1.ColumnDateTime(
      'uploadedAt',
      this,
    );
  }

  late final ImageUpdateTable updateTable;

  late final _i1.ColumnUuid userId;

  late final _i1.ColumnUuid checkId;

  late final _i1.ColumnString url;

  late final _i1.ColumnString metadata;

  late final _i1.ColumnString encryptionKey;

  late final _i1.ColumnString descriptionKey;

  late final _i1.ColumnDateTime uploadedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    checkId,
    url,
    metadata,
    encryptionKey,
    descriptionKey,
    uploadedAt,
  ];
}

class ImageInclude extends _i1.IncludeObject {
  ImageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue> get table => Image.t;
}

class ImageIncludeList extends _i1.IncludeList {
  ImageIncludeList._({
    _i1.WhereExpressionBuilder<ImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Image.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Image.t;
}

class ImageRepository {
  const ImageRepository._();

  /// Returns a list of [Image]s matching the given query parameters.
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
  Future<List<Image>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Image>(
      where: where?.call(Image.t),
      orderBy: orderBy?.call(Image.t),
      orderByList: orderByList?.call(Image.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Image] matching the given query parameters.
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
  Future<Image?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImageTable>? where,
    int? offset,
    _i1.OrderByBuilder<ImageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ImageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Image>(
      where: where?.call(Image.t),
      orderBy: orderBy?.call(Image.t),
      orderByList: orderByList?.call(Image.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Image] by its [id] or null if no such row exists.
  Future<Image?> findById(
    _i1.Session session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Image>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Image]s in the list and returns the inserted rows.
  ///
  /// The returned [Image]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Image>> insert(
    _i1.Session session,
    List<Image> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Image>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Image] and returns the inserted row.
  ///
  /// The returned [Image] will have its `id` field set.
  Future<Image> insertRow(
    _i1.Session session,
    Image row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Image>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Image]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Image>> update(
    _i1.Session session,
    List<Image> rows, {
    _i1.ColumnSelections<ImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Image>(
      rows,
      columns: columns?.call(Image.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Image]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Image> updateRow(
    _i1.Session session,
    Image row, {
    _i1.ColumnSelections<ImageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Image>(
      row,
      columns: columns?.call(Image.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Image] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Image?> updateById(
    _i1.Session session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ImageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Image>(
      id,
      columnValues: columnValues(Image.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Image]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Image>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ImageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ImageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ImageTable>? orderBy,
    _i1.OrderByListBuilder<ImageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Image>(
      columnValues: columnValues(Image.t.updateTable),
      where: where(Image.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Image.t),
      orderByList: orderByList?.call(Image.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Image]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Image>> delete(
    _i1.Session session,
    List<Image> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Image>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Image].
  Future<Image> deleteRow(
    _i1.Session session,
    Image row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Image>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Image>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ImageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Image>(
      where: where(Image.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ImageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Image>(
      where: where?.call(Image.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
