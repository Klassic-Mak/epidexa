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
import '../endpoints/gemini_endpoint.dart' as _i2;
import '../endpoints/profile_endpoint.dart' as _i3;
import '../endpoints/user_endpoint.dart' as _i4;
import 'package:skinaware_server/src/generated/enums/skin_type.dart' as _i5;
import 'package:skinaware_server/src/generated/enums/gender.dart' as _i6;
import 'package:skinaware_server/src/generated/enums/role.dart' as _i7;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i8;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'gemini': _i2.GeminiEndpoint()
        ..initialize(
          server,
          'gemini',
          null,
        ),
      'profile': _i3.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'user': _i4.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['gemini'] = _i1.EndpointConnector(
      name: 'gemini',
      endpoint: endpoints['gemini']!,
      methodConnectors: {
        'ping': _i1.MethodConnector(
          name: 'ping',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gemini'] as _i2.GeminiEndpoint).ping(session),
        ),
        'sendMessage': _i1.MethodConnector(
          name: 'sendMessage',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'historyJson': _i1.ParameterDescription(
              name: 'historyJson',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['gemini'] as _i2.GeminiEndpoint).sendMessage(
                    session,
                    message: params['message'],
                    historyJson: params['historyJson'],
                    userProfileContext: params['userProfileContext'],
                  ),
        ),
        'validateImageBase64': _i1.MethodConnector(
          name: 'validateImageBase64',
          params: {
            'imageBase64': _i1.ParameterDescription(
              name: 'imageBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['gemini'] as _i2.GeminiEndpoint)
                  .validateImageBase64(
                    session,
                    imageBase64: params['imageBase64'],
                    userProfileContext: params['userProfileContext'],
                  ),
        ),
        'analyzeImageBase64': _i1.MethodConnector(
          name: 'analyzeImageBase64',
          params: {
            'imageBase64': _i1.ParameterDescription(
              name: 'imageBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'prompt': _i1.ParameterDescription(
              name: 'prompt',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'skipValidation': _i1.ParameterDescription(
              name: 'skipValidation',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['gemini'] as _i2.GeminiEndpoint)
                  .analyzeImageBase64(
                    session,
                    imageBase64: params['imageBase64'],
                    prompt: params['prompt'],
                    skipValidation: params['skipValidation'],
                    userProfileContext: params['userProfileContext'],
                  ),
        ),
        'sendMessageWithImageBase64': _i1.MethodConnector(
          name: 'sendMessageWithImageBase64',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'imageBase64': _i1.ParameterDescription(
              name: 'imageBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isVietnamese': _i1.ParameterDescription(
              name: 'isVietnamese',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'historyJson': _i1.ParameterDescription(
              name: 'historyJson',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['gemini'] as _i2.GeminiEndpoint)
                  .sendMessageWithImageBase64(
                    session,
                    message: params['message'],
                    imageBase64: params['imageBase64'],
                    isVietnamese: params['isVietnamese'],
                    historyJson: params['historyJson'],
                    userProfileContext: params['userProfileContext'],
                  ),
        ),
        'performFullAnalysisBase64': _i1.MethodConnector(
          name: 'performFullAnalysisBase64',
          params: {
            'imageBase64': _i1.ParameterDescription(
              name: 'imageBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'symptoms': _i1.ParameterDescription(
              name: 'symptoms',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'duration': _i1.ParameterDescription(
              name: 'duration',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'previousTreatments': _i1.ParameterDescription(
              name: 'previousTreatments',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'isVietnamese': _i1.ParameterDescription(
              name: 'isVietnamese',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['gemini'] as _i2.GeminiEndpoint)
                  .performFullAnalysisBase64(
                    session,
                    imageBase64: params['imageBase64'],
                    symptoms: params['symptoms'],
                    duration: params['duration'],
                    previousTreatments: params['previousTreatments'],
                    isVietnamese: params['isVietnamese'],
                    userProfileContext: params['userProfileContext'],
                  ),
        ),
        'streamMessage': _i1.MethodStreamConnector(
          name: 'streamMessage',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'historyJson': _i1.ParameterDescription(
              name: 'historyJson',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'userProfileContext': _i1.ParameterDescription(
              name: 'userProfileContext',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['gemini'] as _i2.GeminiEndpoint).streamMessage(
                session,
                message: params['message'],
                historyJson: params['historyJson'],
                userProfileContext: params['userProfileContext'],
              ),
        ),
      },
    );
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
              type: _i1.getType<_i5.SkinType>(),
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
                  (endpoints['profile'] as _i3.ProfileEndpoint).saveProfile(
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
                  (endpoints['profile'] as _i3.ProfileEndpoint).getByUserId(
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
              type: _i1.getType<_i5.SkinType?>(),
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
                  (endpoints['profile'] as _i3.ProfileEndpoint).updateProfile(
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
              type: _i1.getType<_i6.Gender>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i7.Role>(),
              nullable: false,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i5.SkinType>(),
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
              ) async => (endpoints['user'] as _i4.UserEndpoint).register(
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
              ) async => (endpoints['user'] as _i4.UserEndpoint).login(
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
              type: _i1.getType<_i6.Gender?>(),
              nullable: true,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i7.Role?>(),
              nullable: true,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i5.SkinType?>(),
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
              ) async => (endpoints['user'] as _i4.UserEndpoint).updateUser(
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
              ) async => (endpoints['user'] as _i4.UserEndpoint).getById(
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
              type: _i1.getType<_i6.Gender?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i7.Role?>(),
              nullable: true,
            ),
            'skinType': _i1.ParameterDescription(
              name: 'skinType',
              type: _i1.getType<_i5.SkinType?>(),
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
              ) async => (endpoints['user'] as _i4.UserEndpoint).updateProfile(
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
    modules['serverpod_auth'] = _i8.Endpoints()..initializeEndpoints(server);
  }
}
