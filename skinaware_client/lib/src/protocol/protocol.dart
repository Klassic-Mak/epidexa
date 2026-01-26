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
import 'audit_log.dart' as _i2;
import 'auth_response.dart' as _i3;
import 'consent.dart' as _i4;
import 'consultation.dart' as _i5;
import 'doctor.dart' as _i6;
import 'enums/affected_area.dart' as _i7;
import 'enums/consultation_status.dart' as _i8;
import 'enums/gender.dart' as _i9;
import 'enums/payment_status.dart' as _i10;
import 'enums/role.dart' as _i11;
import 'enums/severity.dart' as _i12;
import 'enums/skin_type.dart' as _i13;
import 'enums/symptom.dart' as _i14;
import 'image.dart' as _i15;
import 'message.dart' as _i16;
import 'payment.dart' as _i17;
import 'recommendation.dart' as _i18;
import 'sender_type.dart' as _i19;
import 'symptom_check.dart' as _i20;
import 'user.dart' as _i21;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i22;
export 'audit_log.dart';
export 'auth_response.dart';
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.AuditLog) {
      return _i2.AuditLog.fromJson(data) as T;
    }
    if (t == _i3.AuthResponse) {
      return _i3.AuthResponse.fromJson(data) as T;
    }
    if (t == _i4.Consent) {
      return _i4.Consent.fromJson(data) as T;
    }
    if (t == _i5.Consultation) {
      return _i5.Consultation.fromJson(data) as T;
    }
    if (t == _i6.Doctor) {
      return _i6.Doctor.fromJson(data) as T;
    }
    if (t == _i7.AffectedArea) {
      return _i7.AffectedArea.fromJson(data) as T;
    }
    if (t == _i8.ConsultationStatus) {
      return _i8.ConsultationStatus.fromJson(data) as T;
    }
    if (t == _i9.Gender) {
      return _i9.Gender.fromJson(data) as T;
    }
    if (t == _i10.PaymentStatus) {
      return _i10.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i11.Role) {
      return _i11.Role.fromJson(data) as T;
    }
    if (t == _i12.Severity) {
      return _i12.Severity.fromJson(data) as T;
    }
    if (t == _i13.SkinType) {
      return _i13.SkinType.fromJson(data) as T;
    }
    if (t == _i14.Symptom) {
      return _i14.Symptom.fromJson(data) as T;
    }
    if (t == _i15.Image) {
      return _i15.Image.fromJson(data) as T;
    }
    if (t == _i16.Message) {
      return _i16.Message.fromJson(data) as T;
    }
    if (t == _i17.Payment) {
      return _i17.Payment.fromJson(data) as T;
    }
    if (t == _i18.Recommendation) {
      return _i18.Recommendation.fromJson(data) as T;
    }
    if (t == _i19.SenderType) {
      return _i19.SenderType.fromJson(data) as T;
    }
    if (t == _i20.SymptomCheck) {
      return _i20.SymptomCheck.fromJson(data) as T;
    }
    if (t == _i21.User) {
      return _i21.User.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuditLog?>()) {
      return (data != null ? _i2.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AuthResponse?>()) {
      return (data != null ? _i3.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Consent?>()) {
      return (data != null ? _i4.Consent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Consultation?>()) {
      return (data != null ? _i5.Consultation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Doctor?>()) {
      return (data != null ? _i6.Doctor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AffectedArea?>()) {
      return (data != null ? _i7.AffectedArea.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ConsultationStatus?>()) {
      return (data != null ? _i8.ConsultationStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Gender?>()) {
      return (data != null ? _i9.Gender.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PaymentStatus?>()) {
      return (data != null ? _i10.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Role?>()) {
      return (data != null ? _i11.Role.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Severity?>()) {
      return (data != null ? _i12.Severity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SkinType?>()) {
      return (data != null ? _i13.SkinType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Symptom?>()) {
      return (data != null ? _i14.Symptom.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Image?>()) {
      return (data != null ? _i15.Image.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Message?>()) {
      return (data != null ? _i16.Message.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Payment?>()) {
      return (data != null ? _i17.Payment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Recommendation?>()) {
      return (data != null ? _i18.Recommendation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.SenderType?>()) {
      return (data != null ? _i19.SenderType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.SymptomCheck?>()) {
      return (data != null ? _i20.SymptomCheck.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.User?>()) {
      return (data != null ? _i21.User.fromJson(data) : null) as T;
    }
    if (t == List<_i14.Symptom>) {
      return (data as List).map((e) => deserialize<_i14.Symptom>(e)).toList()
          as T;
    }
    if (t == List<_i7.AffectedArea>) {
      return (data as List)
              .map((e) => deserialize<_i7.AffectedArea>(e))
              .toList()
          as T;
    }
    try {
      return _i22.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AuditLog => 'AuditLog',
      _i3.AuthResponse => 'AuthResponse',
      _i4.Consent => 'Consent',
      _i5.Consultation => 'Consultation',
      _i6.Doctor => 'Doctor',
      _i7.AffectedArea => 'AffectedArea',
      _i8.ConsultationStatus => 'ConsultationStatus',
      _i9.Gender => 'Gender',
      _i10.PaymentStatus => 'PaymentStatus',
      _i11.Role => 'Role',
      _i12.Severity => 'Severity',
      _i13.SkinType => 'SkinType',
      _i14.Symptom => 'Symptom',
      _i15.Image => 'Image',
      _i16.Message => 'Message',
      _i17.Payment => 'Payment',
      _i18.Recommendation => 'Recommendation',
      _i19.SenderType => 'SenderType',
      _i20.SymptomCheck => 'SymptomCheck',
      _i21.User => 'User',
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
      case _i2.AuditLog():
        return 'AuditLog';
      case _i3.AuthResponse():
        return 'AuthResponse';
      case _i4.Consent():
        return 'Consent';
      case _i5.Consultation():
        return 'Consultation';
      case _i6.Doctor():
        return 'Doctor';
      case _i7.AffectedArea():
        return 'AffectedArea';
      case _i8.ConsultationStatus():
        return 'ConsultationStatus';
      case _i9.Gender():
        return 'Gender';
      case _i10.PaymentStatus():
        return 'PaymentStatus';
      case _i11.Role():
        return 'Role';
      case _i12.Severity():
        return 'Severity';
      case _i13.SkinType():
        return 'SkinType';
      case _i14.Symptom():
        return 'Symptom';
      case _i15.Image():
        return 'Image';
      case _i16.Message():
        return 'Message';
      case _i17.Payment():
        return 'Payment';
      case _i18.Recommendation():
        return 'Recommendation';
      case _i19.SenderType():
        return 'SenderType';
      case _i20.SymptomCheck():
        return 'SymptomCheck';
      case _i21.User():
        return 'User';
    }
    className = _i22.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
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
      return deserialize<_i2.AuditLog>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i3.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Consent') {
      return deserialize<_i4.Consent>(data['data']);
    }
    if (dataClassName == 'Consultation') {
      return deserialize<_i5.Consultation>(data['data']);
    }
    if (dataClassName == 'Doctor') {
      return deserialize<_i6.Doctor>(data['data']);
    }
    if (dataClassName == 'AffectedArea') {
      return deserialize<_i7.AffectedArea>(data['data']);
    }
    if (dataClassName == 'ConsultationStatus') {
      return deserialize<_i8.ConsultationStatus>(data['data']);
    }
    if (dataClassName == 'Gender') {
      return deserialize<_i9.Gender>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i10.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Role') {
      return deserialize<_i11.Role>(data['data']);
    }
    if (dataClassName == 'Severity') {
      return deserialize<_i12.Severity>(data['data']);
    }
    if (dataClassName == 'SkinType') {
      return deserialize<_i13.SkinType>(data['data']);
    }
    if (dataClassName == 'Symptom') {
      return deserialize<_i14.Symptom>(data['data']);
    }
    if (dataClassName == 'Image') {
      return deserialize<_i15.Image>(data['data']);
    }
    if (dataClassName == 'Message') {
      return deserialize<_i16.Message>(data['data']);
    }
    if (dataClassName == 'Payment') {
      return deserialize<_i17.Payment>(data['data']);
    }
    if (dataClassName == 'Recommendation') {
      return deserialize<_i18.Recommendation>(data['data']);
    }
    if (dataClassName == 'SenderType') {
      return deserialize<_i19.SenderType>(data['data']);
    }
    if (dataClassName == 'SymptomCheck') {
      return deserialize<_i20.SymptomCheck>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i21.User>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i22.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

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
      return _i22.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
