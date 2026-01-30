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

enum AffectedArea implements _i1.SerializableModel {
  FACE,
  HANDS,
  ARMS,
  LEGS,
  BACK,
  NECK,
  CHEST,
  OTHER;

  static AffectedArea fromJson(String name) {
    switch (name) {
      case 'FACE':
        return AffectedArea.FACE;
      case 'HANDS':
        return AffectedArea.HANDS;
      case 'ARMS':
        return AffectedArea.ARMS;
      case 'LEGS':
        return AffectedArea.LEGS;
      case 'BACK':
        return AffectedArea.BACK;
      case 'NECK':
        return AffectedArea.NECK;
      case 'CHEST':
        return AffectedArea.CHEST;
      case 'OTHER':
        return AffectedArea.OTHER;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "AffectedArea"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
