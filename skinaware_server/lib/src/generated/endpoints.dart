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
import '../endpoints/profile_endpoint.dart' as _i2;
import '../endpoints/user_endpoint.dart' as _i3;
import 'package:skinaware_server/src/generated/enums/skin_type.dart' as _i4;
import 'package:skinaware_server/src/generated/enums/gender.dart' as _i5;
import 'package:skinaware_server/src/generated/enums/role.dart' as _i6;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i7;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'profile': _i2.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'user': _i3.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['profile'] = _i1.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'saveProfile': _i1.MethodConnector(
          name: 'saveProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i4.SkinType>(),
              nullable: false,
            ),
            'skinSensitivity': _i1.ParameterDescription(
              name: 'skinSensitivity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'oiliness': _i1.ParameterDescription(
              name: 'oiliness',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinConcerns': _i1.ParameterDescription(
              name: 'skinConcerns',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'primaryConcern': _i1.ParameterDescription(
              name: 'primaryConcern',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'knownAllergies': _i1.ParameterDescription(
              name: 'knownAllergies',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'currentMedications': _i1.ParameterDescription(
              name: 'currentMedications',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinConditionHistory': _i1.ParameterDescription(
              name: 'skinConditionHistory',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sunExposure': _i1.ParameterDescription(
              name: 'sunExposure',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'waterIntake': _i1.ParameterDescription(
              name: 'waterIntake',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sleepQuality': _i1.ParameterDescription(
              name: 'sleepQuality',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'stressLevel': _i1.ParameterDescription(
              name: 'stressLevel',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinGoals': _i1.ParameterDescription(
              name: 'skinGoals',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'preferredLanguage': _i1.ParameterDescription(
              name: 'preferredLanguage',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'productBudget': _i1.ParameterDescription(
              name: 'productBudget',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'routineComplexity': _i1.ParameterDescription(
              name: 'routineComplexity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2.ProfileEndpoint).saveProfile(
                    session,
                    userId: params['userId'],
                    skinType: params['skinType'],
                    skinSensitivity: params['skinSensitivity'],
                    oiliness: params['oiliness'],
                    skinConcerns: params['skinConcerns'],
                    primaryConcern: params['primaryConcern'],
                    knownAllergies: params['knownAllergies'],
                    currentMedications: params['currentMedications'],
                    skinConditionHistory: params['skinConditionHistory'],
                    sunExposure: params['sunExposure'],
                    waterIntake: params['waterIntake'],
                    sleepQuality: params['sleepQuality'],
                    stressLevel: params['stressLevel'],
                    skinGoals: params['skinGoals'],
                    preferredLanguage: params['preferredLanguage'],
                    productBudget: params['productBudget'],
                    routineComplexity: params['routineComplexity'],
                  ),
        ),
        'getByUserId': _i1.MethodConnector(
          name: 'getByUserId',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2.ProfileEndpoint).getByUserId(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i4.SkinType?>(),
              nullable: true,
            ),
            'skinSensitivity': _i1.ParameterDescription(
              name: 'skinSensitivity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'oiliness': _i1.ParameterDescription(
              name: 'oiliness',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinConcerns': _i1.ParameterDescription(
              name: 'skinConcerns',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'primaryConcern': _i1.ParameterDescription(
              name: 'primaryConcern',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'knownAllergies': _i1.ParameterDescription(
              name: 'knownAllergies',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'currentMedications': _i1.ParameterDescription(
              name: 'currentMedications',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinConditionHistory': _i1.ParameterDescription(
              name: 'skinConditionHistory',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sunExposure': _i1.ParameterDescription(
              name: 'sunExposure',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'waterIntake': _i1.ParameterDescription(
              name: 'waterIntake',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'sleepQuality': _i1.ParameterDescription(
              name: 'sleepQuality',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'stressLevel': _i1.ParameterDescription(
              name: 'stressLevel',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skinGoals': _i1.ParameterDescription(
              name: 'skinGoals',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'preferredLanguage': _i1.ParameterDescription(
              name: 'preferredLanguage',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'productBudget': _i1.ParameterDescription(
              name: 'productBudget',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'routineComplexity': _i1.ParameterDescription(
              name: 'routineComplexity',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2.ProfileEndpoint).updateProfile(
                    session,
                    userId: params['userId'],
                    skinType: params['skinType'],
                    skinSensitivity: params['skinSensitivity'],
                    oiliness: params['oiliness'],
                    skinConcerns: params['skinConcerns'],
                    primaryConcern: params['primaryConcern'],
                    knownAllergies: params['knownAllergies'],
                    currentMedications: params['currentMedications'],
                    skinConditionHistory: params['skinConditionHistory'],
                    sunExposure: params['sunExposure'],
                    waterIntake: params['waterIntake'],
                    sleepQuality: params['sleepQuality'],
                    stressLevel: params['stressLevel'],
                    skinGoals: params['skinGoals'],
                    preferredLanguage: params['preferredLanguage'],
                    productBudget: params['productBudget'],
                    routineComplexity: params['routineComplexity'],
                  ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'register': _i1.MethodConnector(
          name: 'register',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'age': _i1.ParameterDescription(
              name: 'age',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'gender': _i1.ParameterDescription(
              name: 'gender',
              type: _i1.getType<_i5.Gender>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i6.Role>(),
              nullable: false,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i4.SkinType>(),
              nullable: false,
            ),
            'profilePhoto': _i1.ParameterDescription(
              name: 'profilePhoto',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i3.UserEndpoint).register(
                session,
                email: params['email'],
                password: params['password'],
                phone: params['phone'],
                age: params['age'],
                gender: params['gender'],
                name: params['name'],
                role: params['role'],
                skinType: params['skinType'],
                profilePhoto: params['profilePhoto'],
              ),
        ),
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i3.UserEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'updateUser': _i1.MethodConnector(
          name: 'updateUser',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'age': _i1.ParameterDescription(
              name: 'age',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'gender': _i1.ParameterDescription(
              name: 'gender',
              type: _i1.getType<_i5.Gender?>(),
              nullable: true,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i6.Role?>(),
              nullable: true,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i4.SkinType?>(),
              nullable: true,
            ),
            'profilePhoto': _i1.ParameterDescription(
              name: 'profilePhoto',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i3.UserEndpoint).updateUser(
                session,
                userId: params['userId'],
                email: params['email'],
                password: params['password'],
                phone: params['phone'],
                age: params['age'],
                gender: params['gender'],
                name: params['name'],
                role: params['role'],
                skinType: params['skinType'],
                profilePhoto: params['profilePhoto'],
              ),
        ),
        'getById': _i1.MethodConnector(
          name: 'getById',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i3.UserEndpoint).getById(
                session,
                userId: params['userId'],
              ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'age': _i1.ParameterDescription(
              name: 'age',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'gender': _i1.ParameterDescription(
              name: 'gender',
              type: _i1.getType<_i5.Gender?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i6.Role?>(),
              nullable: true,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i4.SkinType?>(),
              nullable: true,
            ),
            'profilePhoto': _i1.ParameterDescription(
              name: 'profilePhoto',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i3.UserEndpoint).updateProfile(
                session,
                userId: params['userId'],
                name: params['name'],
                phone: params['phone'],
                age: params['age'],
                gender: params['gender'],
                role: params['role'],
                skinType: params['skinType'],
                profilePhoto: params['profilePhoto'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i7.Endpoints()..initializeEndpoints(server);
  }
}
