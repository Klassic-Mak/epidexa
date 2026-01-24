import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinaware_client/skinaware_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinaware_flutter/routes/route_constants.dart';
import 'package:skinaware_flutter/routes/router.dart';
import 'package:skinaware_flutter/theme/theme.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'config/app_config.dart';

late final Client client;

late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');

  // final config = await AppConfig.loadConfig();
  // final serverUrl = serverUrlFromEnv.isEmpty
  //     ? config.apiUrl ?? 'http://$localhost:8080/'
  //     : serverUrlFromEnv;

  // client = Client(serverUrl)
  //   ..connectivityMonitor = FlutterConnectivityMonitor()
  //   ..authSessionManager = FlutterAuthSessionManager();

  // client.auth.initialize();

  await ScreenUtil.ensureScreenSize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Epidexa',
        theme: lightmode,
        initialRoute: mainPageRoute,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
