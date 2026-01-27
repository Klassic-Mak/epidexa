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
import 'package:skinaware_client/src/protocol/auth_response.dart' as _i3;
import 'package:skinaware_client/src/protocol/enums/gender.dart' as _i4;
import 'package:skinaware_client/src/protocol/enums/role.dart' as _i5;
import 'package:skinaware_client/src/protocol/enums/skin_type.dart' as _i6;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i7;
import 'protocol.dart' as _i8;

/// {@category Endpoint}
class EndpointUser extends _i1.EndpointRef {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i3.AuthResponse> register({
    required String email,
    required String password,
    required String phone,
    required int age,
    required _i4.Gender gender,
    required String name,
    required _i5.Role role,
    required _i6.SkinType skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i3.AuthResponse>(
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

  _i2.Future<_i3.AuthResponse> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i3.AuthResponse>(
    'user',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  _i2.Future<_i3.AuthResponse> updateUser({
    required _i1.UuidValue userId,
    String? email,
    String? password,
    String? phone,
    int? age,
    _i4.Gender? gender,
    String? name,
    _i5.Role? role,
    _i6.SkinType? skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i3.AuthResponse>(
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

  _i2.Future<_i3.AuthResponse> getById({required _i1.UuidValue userId}) =>
      caller.callServerEndpoint<_i3.AuthResponse>(
        'user',
        'getById',
        {'userId': userId},
      );

  _i2.Future<_i3.AuthResponse> updateProfile({
    required _i1.UuidValue userId,
    String? name,
    String? phone,
    int? age,
    _i4.Gender? gender,
    _i5.Role? role,
    _i6.SkinType? skinType,
    String? profilePhoto,
  }) => caller.callServerEndpoint<_i3.AuthResponse>(
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
    auth = _i7.Caller(client);
  }

  late final _i7.Caller auth;
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
         _i8.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'user': user};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
