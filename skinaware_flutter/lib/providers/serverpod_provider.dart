import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_client/skinaware_client.dart'; // your generated client package

const serverUrl = 'http://localhost:8080/'; // change to your server url

final serverpodClientProvider = Provider<Client>((ref) {
  final client = Client(serverUrl);
  // If you use auth/session later, you can attach key manager here.
  return client;
});
