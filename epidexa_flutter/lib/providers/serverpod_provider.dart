// serverpod_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_client/skinaware_client.dart';

const _dartDefineServerUrl = String.fromEnvironment(
  'SERVERPOD_URL',
  defaultValue: '',
);

// this is a hosted serverpod server url for epidexa app
//if you're running your own server, replace this with your server url
// androind emulator use http://10.0.2.2:8080/
// ios simulator use http://localhost:8080/

const _hostedServerUrl = 'https://epidexa-498245313775.europe-west1.run.app/';

final serverpodClientProvider = Provider<Client>((ref) {
  final serverUrl = _dartDefineServerUrl.isNotEmpty
      ? _dartDefineServerUrl
      : _hostedServerUrl;

  final client = Client(serverUrl);

  return client;
});
