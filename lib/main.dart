import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/application/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'package:wodobro/application/workmanager.dart';
import 'domain/notification_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('starting app');
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}
  print('firebase inited');
  await FlutterDisplayMode.setHighRefreshRate();

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
      systemNavigationBarDividerColor: Colors.black.withOpacity(0.002),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  await GetStorage.init();
  await Notifications.init();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  setup();
  print('setup done');
  runApp(const Wodobro());
}

class Wodobro extends StatelessWidget {
  const Wodobro({super.key});

  static const String title = 'Wodobro';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
      );
}
