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
import '../endpoints/user_endpoint.dart' as _i2;
import 'package:skinaware_server/src/generated/enums/gender.dart' as _i3;
import 'package:skinaware_server/src/generated/enums/role.dart' as _i4;
import 'package:skinaware_server/src/generated/enums/skin_type.dart' as _i5;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'user': _i2.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
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
              type: _i1.getType<_i3.Gender>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i4.Role>(),
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
              ) async => (endpoints['user'] as _i2.UserEndpoint).register(
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
              ) async => (endpoints['user'] as _i2.UserEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
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
              ) async => (endpoints['user'] as _i2.UserEndpoint).getById(
                session,
                userId: params['userId'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i6.Endpoints()..initializeEndpoints(server);
  }
}
