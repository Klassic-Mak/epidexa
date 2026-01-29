// serverpod_provider.dart
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_client/skinaware_client.dart';

const _dartDefineServerUrl = String.fromEnvironment(
  'SERVERPOD_URL',
  defaultValue: '',
);

String _computeDefaultServerUrl() {
  const port = 8080;

  if (kIsWeb) {
    return 'http://localhost:$port/';
  }

  try {
    // please change this aspect to your IP Address if you're on a real device, for emulators, use 10.0.2.2:{PORT}
    if (Platform.isAndroid) {
      return 'http://192.168.43.152:$port/';
    }

    // iOS simulator: localhost works
    if (Platform.isIOS) {
      return 'http://localhost:$port/';
    }
  } catch (_) {}

  return 'http://localhost:$port/';
}

final serverpodClientProvider = Provider<Client>((ref) {
  // Priority: SERVERPOD_URL dart-define > platform defaults
  final serverUrl = _dartDefineServerUrl.isNotEmpty
      ? _dartDefineServerUrl
      : _computeDefaultServerUrl();

  final client = Client(serverUrl);

  return client;
});
