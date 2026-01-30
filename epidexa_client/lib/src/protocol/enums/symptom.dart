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

enum Symptom implements _i1.SerializableModel {
  ACNE,
  RASH,
  DRYNESS,
  ITCHING,
  PIGMENTATION,
  BLEEDING,
  BURNING,
  INFECTION,
  OTHER;

  static Symptom fromJson(String name) {
    switch (name) {
      case 'ACNE':
        return Symptom.ACNE;
      case 'RASH':
        return Symptom.RASH;
      case 'DRYNESS':
        return Symptom.DRYNESS;
      case 'ITCHING':
        return Symptom.ITCHING;
      case 'PIGMENTATION':
        return Symptom.PIGMENTATION;
      case 'BLEEDING':
        return Symptom.BLEEDING;
      case 'BURNING':
        return Symptom.BURNING;
      case 'INFECTION':
        return Symptom.INFECTION;
      case 'OTHER':
        return Symptom.OTHER;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "Symptom"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
