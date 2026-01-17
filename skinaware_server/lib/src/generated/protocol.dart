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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'audit_log.dart' as _i5;
import 'consent.dart' as _i6;
import 'consultation.dart' as _i7;
import 'doctor.dart' as _i8;
import 'enums/affected_area.dart' as _i9;
import 'enums/consultation_status.dart' as _i10;
import 'enums/gender.dart' as _i11;
import 'enums/payment_status.dart' as _i12;
import 'enums/role.dart' as _i13;
import 'enums/severity.dart' as _i14;
import 'enums/skin_type.dart' as _i15;
import 'enums/symptom.dart' as _i16;
import 'image.dart' as _i17;
import 'message.dart' as _i18;
import 'payment.dart' as _i19;
import 'recommendation.dart' as _i20;
import 'sender_type.dart' as _i21;
import 'symptom_check.dart' as _i22;
import 'user.dart' as _i23;
export 'audit_log.dart';
export 'consent.dart';
export 'consultation.dart';
export 'doctor.dart';
export 'enums/affected_area.dart';
export 'enums/consultation_status.dart';
export 'enums/gender.dart';
export 'enums/payment_status.dart';
export 'enums/role.dart';
export 'enums/severity.dart';
export 'enums/skin_type.dart';
export 'enums/symptom.dart';
export 'image.dart';
export 'message.dart';
export 'payment.dart';
export 'recommendation.dart';
export 'sender_type.dart';
export 'symptom_check.dart';
export 'user.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'app_user',
      dartName: 'User',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'age',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'gender',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Gender',
        ),
        _i2.ColumnDefinition(
          name: 'passwordHash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Role',
        ),
        _i2.ColumnDefinition(
          name: 'skinType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SkinType',
        ),
        _i2.ColumnDefinition(
          name: 'profilePhoto',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'app_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'audit_log',
      dartName: 'AuditLog',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'action',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'ip',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'audit_log_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'audit_log_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'consent',
      dartName: 'Consent',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'accepted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'consent_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'consent_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'consultation',
      dartName: 'Consultation',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'doctorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'checkId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ConsultationStatus',
        ),
        _i2.ColumnDefinition(
          name: 'doctorNotesKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'respondedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'consultation_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'consultation_fk_1',
          columns: ['doctorId'],
          referenceTable: 'doctor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'consultation_fk_2',
          columns: ['checkId'],
          referenceTable: 'symptom_check',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'consultation_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'doctor',
      dartName: 'Doctor',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'credentialsKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'licenseNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'verified',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'availability',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'fee',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'doctor_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'doctor_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'image',
      dartName: 'Image',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'checkId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'metadata',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'descriptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'uploadedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'image_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'image_fk_1',
          columns: ['checkId'],
          referenceTable: 'symptom_check',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'image_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'message',
      dartName: 'Message',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'consultationId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'senderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'senderType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SenderType',
        ),
        _i2.ColumnDefinition(
          name: 'messageKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'message_fk_0',
          columns: ['consultationId'],
          referenceTable: 'consultation',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'message_fk_1',
          columns: ['senderId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'payment',
      dartName: 'Payment',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'consultationId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentStatus',
        ),
        _i2.ColumnDefinition(
          name: 'provider',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'transactionId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_fk_1',
          columns: ['consultationId'],
          referenceTable: 'consultation',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'payment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'recommendation',
      dartName: 'Recommendation',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'checkId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'severity',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Severity',
        ),
        _i2.ColumnDefinition(
          name: 'tipsKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'warningsKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'recommendation_fk_0',
          columns: ['checkId'],
          referenceTable: 'symptom_check',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'recommendation_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'symptom_check',
      dartName: 'SymptomCheck',
      schema: 'public',
      module: 'skinaware',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'skinType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SkinType',
        ),
        _i2.ColumnDefinition(
          name: 'symptoms',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:Symptom>',
        ),
        _i2.ColumnDefinition(
          name: 'affectedAreas',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:AffectedArea>',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'severity',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Severity',
        ),
        _i2.ColumnDefinition(
          name: 'notesKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'encryptionKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'symptom_check_fk_0',
          columns: ['userId'],
          referenceTable: 'app_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'symptom_check_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.AuditLog) {
      return _i5.AuditLog.fromJson(data) as T;
    }
    if (t == _i6.Consent) {
      return _i6.Consent.fromJson(data) as T;
    }
    if (t == _i7.Consultation) {
      return _i7.Consultation.fromJson(data) as T;
    }
    if (t == _i8.Doctor) {
      return _i8.Doctor.fromJson(data) as T;
    }
    if (t == _i9.AffectedArea) {
      return _i9.AffectedArea.fromJson(data) as T;
    }
    if (t == _i10.ConsultationStatus) {
      return _i10.ConsultationStatus.fromJson(data) as T;
    }
    if (t == _i11.Gender) {
      return _i11.Gender.fromJson(data) as T;
    }
    if (t == _i12.PaymentStatus) {
      return _i12.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i13.Role) {
      return _i13.Role.fromJson(data) as T;
    }
    if (t == _i14.Severity) {
      return _i14.Severity.fromJson(data) as T;
    }
    if (t == _i15.SkinType) {
      return _i15.SkinType.fromJson(data) as T;
    }
    if (t == _i16.Symptom) {
      return _i16.Symptom.fromJson(data) as T;
    }
    if (t == _i17.Image) {
      return _i17.Image.fromJson(data) as T;
    }
    if (t == _i18.Message) {
      return _i18.Message.fromJson(data) as T;
    }
    if (t == _i19.Payment) {
      return _i19.Payment.fromJson(data) as T;
    }
    if (t == _i20.Recommendation) {
      return _i20.Recommendation.fromJson(data) as T;
    }
    if (t == _i21.SenderType) {
      return _i21.SenderType.fromJson(data) as T;
    }
    if (t == _i22.SymptomCheck) {
      return _i22.SymptomCheck.fromJson(data) as T;
    }
    if (t == _i23.User) {
      return _i23.User.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AuditLog?>()) {
      return (data != null ? _i5.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Consent?>()) {
      return (data != null ? _i6.Consent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Consultation?>()) {
      return (data != null ? _i7.Consultation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Doctor?>()) {
      return (data != null ? _i8.Doctor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.AffectedArea?>()) {
      return (data != null ? _i9.AffectedArea.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ConsultationStatus?>()) {
      return (data != null ? _i10.ConsultationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.Gender?>()) {
      return (data != null ? _i11.Gender.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.PaymentStatus?>()) {
      return (data != null ? _i12.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Role?>()) {
      return (data != null ? _i13.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Severity?>()) {
      return (data != null ? _i14.Severity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.SkinType?>()) {
      return (data != null ? _i15.SkinType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Symptom?>()) {
      return (data != null ? _i16.Symptom.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Image?>()) {
      return (data != null ? _i17.Image.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Message?>()) {
      return (data != null ? _i18.Message.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Payment?>()) {
      return (data != null ? _i19.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Recommendation?>()) {
      return (data != null ? _i20.Recommendation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.SenderType?>()) {
      return (data != null ? _i21.SenderType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.SymptomCheck?>()) {
      return (data != null ? _i22.SymptomCheck.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.User?>()) {
      return (data != null ? _i23.User.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Symptom>) {
      return (data as List).map((e) => deserialize<_i16.Symptom>(e)).toList()
          as T;
    }
    if (t == List<_i9.AffectedArea>) {
      return (data as List)
              .map((e) => deserialize<_i9.AffectedArea>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.AuditLog => 'AuditLog',
      _i6.Consent => 'Consent',
      _i7.Consultation => 'Consultation',
      _i8.Doctor => 'Doctor',
      _i9.AffectedArea => 'AffectedArea',
      _i10.ConsultationStatus => 'ConsultationStatus',
      _i11.Gender => 'Gender',
      _i12.PaymentStatus => 'PaymentStatus',
      _i13.Role => 'Role',
      _i14.Severity => 'Severity',
      _i15.SkinType => 'SkinType',
      _i16.Symptom => 'Symptom',
      _i17.Image => 'Image',
      _i18.Message => 'Message',
      _i19.Payment => 'Payment',
      _i20.Recommendation => 'Recommendation',
      _i21.SenderType => 'SenderType',
      _i22.SymptomCheck => 'SymptomCheck',
      _i23.User => 'User',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('skinaware.', '');
    }

    switch (data) {
      case _i5.AuditLog():
        return 'AuditLog';
      case _i6.Consent():
        return 'Consent';
      case _i7.Consultation():
        return 'Consultation';
      case _i8.Doctor():
        return 'Doctor';
      case _i9.AffectedArea():
        return 'AffectedArea';
      case _i10.ConsultationStatus():
        return 'ConsultationStatus';
      case _i11.Gender():
        return 'Gender';
      case _i12.PaymentStatus():
        return 'PaymentStatus';
      case _i13.Role():
        return 'Role';
      case _i14.Severity():
        return 'Severity';
      case _i15.SkinType():
        return 'SkinType';
      case _i16.Symptom():
        return 'Symptom';
      case _i17.Image():
        return 'Image';
      case _i18.Message():
        return 'Message';
      case _i19.Payment():
        return 'Payment';
      case _i20.Recommendation():
        return 'Recommendation';
      case _i21.SenderType():
        return 'SenderType';
      case _i22.SymptomCheck():
        return 'SymptomCheck';
      case _i23.User():
        return 'User';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_i5.AuditLog>(data['data']);
    }
    if (dataClassName == 'Consent') {
      return deserialize<_i6.Consent>(data['data']);
    }
    if (dataClassName == 'Consultation') {
      return deserialize<_i7.Consultation>(data['data']);
    }
    if (dataClassName == 'Doctor') {
      return deserialize<_i8.Doctor>(data['data']);
    }
    if (dataClassName == 'AffectedArea') {
      return deserialize<_i9.AffectedArea>(data['data']);
    }
    if (dataClassName == 'ConsultationStatus') {
      return deserialize<_i10.ConsultationStatus>(data['data']);
    }
    if (dataClassName == 'Gender') {
      return deserialize<_i11.Gender>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i12.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i13.Role>(data['data']);
    }
    if (dataClassName == 'Severity') {
      return deserialize<_i14.Severity>(data['data']);
    }
    if (dataClassName == 'SkinType') {
      return deserialize<_i15.SkinType>(data['data']);
    }
    if (dataClassName == 'Symptom') {
      return deserialize<_i16.Symptom>(data['data']);
    }
    if (dataClassName == 'Image') {
      return deserialize<_i17.Image>(data['data']);
    }
    if (dataClassName == 'Message') {
      return deserialize<_i18.Message>(data['data']);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i19.Payment>(data['data']);
    }
    if (dataClassName == 'Recommendation') {
      return deserialize<_i20.Recommendation>(data['data']);
    }
    if (dataClassName == 'SenderType') {
      return deserialize<_i21.SenderType>(data['data']);
    }
    if (dataClassName == 'SymptomCheck') {
      return deserialize<_i22.SymptomCheck>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i23.User>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.AuditLog:
        return _i5.AuditLog.t;
      case _i6.Consent:
        return _i6.Consent.t;
      case _i7.Consultation:
        return _i7.Consultation.t;
      case _i8.Doctor:
        return _i8.Doctor.t;
      case _i17.Image:
        return _i17.Image.t;
      case _i18.Message:
        return _i18.Message.t;
      case _i19.Payment:
        return _i19.Payment.t;
      case _i20.Recommendation:
        return _i20.Recommendation.t;
      case _i22.SymptomCheck:
        return _i22.SymptomCheck.t;
      case _i23.User:
        return _i23.User.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'skinaware';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
