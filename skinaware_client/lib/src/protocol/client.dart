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
import 'dart:async' as _i2;
import 'package:skinaware_client/src/protocol/profile_response.dart' as _i3;
import 'package:skinaware_client/src/protocol/enums/skin_type.dart' as _i4;
import 'package:skinaware_client/src/protocol/auth_response.dart' as _i5;
import 'package:skinaware_client/src/protocol/enums/gender.dart' as _i6;
import 'package:skinaware_client/src/protocol/enums/role.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'protocol.dart' as _i9;

/// {@category Endpoint}
class EndpointGemini extends _i1.EndpointRef {
  EndpointGemini(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'gemini';

  /// ------------------------------------------------------------
  /// 1) Initialize: just a health/test call
  /// ------------------------------------------------------------
  _i2.Future<bool> ping() => caller.callServerEndpoint<bool>(
    'gemini',
    'ping',
    {},
  );

  /// ------------------------------------------------------------
  /// 2) sendMessage (non-stream)
  /// - historyJson is optional: JSON list of {role, content}
  /// ------------------------------------------------------------
  _i2.Future<String> sendMessage({
    required String message,
    String? historyJson,
    required String userProfileContext,
  }) => caller.callServerEndpoint<String>(
    'gemini',
    'sendMessage',
    {
      'message': message,
      'historyJson': historyJson,
      'userProfileContext': userProfileContext,
    },
  );

  /// ------------------------------------------------------------
  /// 3) streamMessage
  /// ------------------------------------------------------------
  _i2.Stream<String> streamMessage({
    required String message,
    String? historyJson,
    required String userProfileContext,
  }) => caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
    'gemini',
    'streamMessage',
    {
      'message': message,
      'historyJson': historyJson,
      'userProfileContext': userProfileContext,
    },
    {},
  );

  /// ------------------------------------------------------------
  /// 4) validateImageBase64
  /// Returns: String starting with "VALID: ..." or "INVALID: ..."
  /// ------------------------------------------------------------
  _i2.Future<String> validateImageBase64({
    required String imageBase64,
    required String userProfileContext,
  }) => caller.callServerEndpoint<String>(
    'gemini',
    'validateImageBase64',
    {
      'imageBase64': imageBase64,
      'userProfileContext': userProfileContext,
    },
  );

  /// ------------------------------------------------------------
  /// 5) analyzeImageBase64
  /// ------------------------------------------------------------
  _i2.Future<String> analyzeImageBase64({
    required String imageBase64,
    String? prompt,
    required bool skipValidation,
    required String userProfileContext,
  }) => caller.callServerEndpoint<String>(
    'gemini',
    'analyzeImageBase64',
    {
      'imageBase64': imageBase64,
      'prompt': prompt,
      'skipValidation': skipValidation,
      'userProfileContext': userProfileContext,
    },
  );

  /// ------------------------------------------------------------
  /// 6) sendMessageWithImageBase64
  /// - validates image
  /// - runs vision analysis
  /// - combines with message
  /// ------------------------------------------------------------
  _i2.Future<String> sendMessageWithImageBase64({
    required String message,
    required String imageBase64,
    required bool isVietnamese,
    String? historyJson,
    required String userProfileContext,
  }) => caller.callServerEndpoint<String>(
    'gemini',
    'sendMessageWithImageBase64',
    {
      'message': message,
      'imageBase64': imageBase64,
      'isVietnamese': isVietnamese,
      'historyJson': historyJson,
      'userProfileContext': userProfileContext,
    },
  );

  /// ------------------------------------------------------------
  /// 7) performFullAnalysisBase64 -> returns JSON string
  /// (so you can parse into your AnalysisResult on Flutter)
  /// ------------------------------------------------------------
  _i2.Future<String> performFullAnalysisBase64({
    required String imageBase64,
    String? symptoms,
    String? duration,
    String? previousTreatments,
    required bool isVietnamese,
    required String userProfileContext,
  }) => caller.callServerEndpoint<String>(
    'gemini',
    'performFullAnalysisBase64',
    {
      'imageBase64': imageBase64,
      'symptoms': symptoms,
      'duration': duration,
      'previousTreatments': previousTreatments,
      'isVietnamese': isVietnamese,
      'userProfileContext': userProfileContext,
    },
  );
}

/// {@category Endpoint}
class EndpointProfile extends _i1.EndpointRef {
  EndpointProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// Create or update user profile from onboarding data
  _i2.Future<_i3.ProfileResponse> saveProfile({
    required _i1.UuidValue userId,
    required _i4.SkinType skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
  }) => caller.callServerEndpoint<_i3.ProfileResponse>(
    'profile',
    'saveProfile',
    {
      'userId': userId,
      'skinType': skinType,
      'skinSensitivity': skinSensitivity,
      'oiliness': oiliness,
      'skinConcerns': skinConcerns,
      'primaryConcern': primaryConcern,
      'knownAllergies': knownAllergies,
      'currentMedications': currentMedications,
      'skinConditionHistory': skinConditionHistory,
      'sunExposure': sunExposure,
      'waterIntake': waterIntake,
      'sleepQuality': sleepQuality,
      'stressLevel': stressLevel,
      'skinGoals': skinGoals,
      'preferredLanguage': preferredLanguage,
      'productBudget': productBudget,
      'routineComplexity': routineComplexity,
    },
  );

  /// Get user profile by user ID
  _i2.Future<_i3.ProfileResponse> getByUserId({
    required _i1.UuidValue userId,
  }) => caller.callServerEndpoint<_i3.ProfileResponse>(
    'profile',
    'getByUserId',
    {'userId': userId},
  );

  /// Update specific profile fields
  _i2.Future<_i3.ProfileResponse> updateProfile({
    required _i1.UuidValue userId,
    _i4.SkinType? skinType,
    String? skinSensitivity,
    String? oiliness,
    String? skinConcerns,
    String? primaryConcern,
    String? knownAllergies,
    String? currentMedications,
    String? skinConditionHistory,
    String? sunExposure,
    String? waterIntake,
    String? sleepQuality,
    String? stressLevel,
    String? skinGoals,
    String? preferredLanguage,
    String? productBudget,
    String? routineComplexity,
  }) => caller.callServerEndpoint<_i3.ProfileResponse>(
    'profile',
    'updateProfile',
    {
      'userId': userId,
      'skinType': skinType,
      'skinSensitivity': skinSensitivity,
      'oiliness': oiliness,
      'skinConcerns': skinConcerns,
      'primaryConcern': primaryConcern,
      'knownAllergies': knownAllergies,
      'currentMedications': currentMedications,
      'skinConditionHistory': skinConditionHistory,
      'sunExposure': sunExposure,
      'waterIntake': waterIntake,
      'sleepQuality': sleepQuality,
      'stressLevel': stressLevel,
      'skinGoals': skinGoals,
      'preferredLanguage': preferredLanguage,
      'productBudget': productBudget,
      'routineComplexity': routineComplexity,
    },
  );
}

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i5.AuthResponse> register({
    required String email,
    required String password,
    required String phone,
    required int age,
    required _i6.Gender gender,
    required String name,
    required _i7.Role role,
    required _i4.SkinType skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i5.AuthResponse>(
    'user',
    'register',
    {
      'email': email,
      'password': password,
      'phone': phone,
      'age': age,
      'gender': gender,
      'name': name,
      'role': role,
      'skinType': skinType,
      'profilePhoto': profilePhoto,
    },
  );

  _i2.Future<_i5.AuthResponse> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i5.AuthResponse>(
    'user',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  _i2.Future<_i5.AuthResponse> updateUser({
    required _i1.UuidValue userId,
    String? email,
    String? password,
    String? phone,
    int? age,
    _i6.Gender? gender,
    String? name,
    _i7.Role? role,
    _i4.SkinType? skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i5.AuthResponse>(
    'user',
    'updateUser',
    {
      'userId': userId,
      'email': email,
      'password': password,
      'phone': phone,
      'age': age,
      'gender': gender,
      'name': name,
      'role': role,
      'skinType': skinType,
      'profilePhoto': profilePhoto,
    },
  );

  _i2.Future<_i5.AuthResponse> getById({required _i1.UuidValue userId}) =>
      caller.callServerEndpoint<_i5.AuthResponse>(
        'user',
        'getById',
        {'userId': userId},
      );

  _i2.Future<_i5.AuthResponse> updateProfile({
    required _i1.UuidValue userId,
    String? name,
    String? phone,
    int? age,
    _i6.Gender? gender,
    _i7.Role? role,
    _i4.SkinType? skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i5.AuthResponse>(
    'user',
    'updateProfile',
    {
      'userId': userId,
      'name': name,
      'phone': phone,
      'age': age,
      'gender': gender,
      'role': role,
      'skinType': skinType,
      'profilePhoto': profilePhoto,
    },
  );
}

class Modules {
  Modules(Client client) {
    auth = _i8.Caller(client);
  }

  late final _i8.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i9.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    gemini = EndpointGemini(this);
    profile = EndpointProfile(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointGemini gemini;

  late final EndpointProfile profile;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'gemini': gemini,
    'profile': profile,
    'user': user,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
