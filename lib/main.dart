import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/locator.dart';
import 'dart:io';
import 'package:wodobro/application/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  print('starting app');
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {}
  print('firebase inited');


  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.black.withOpacity(0.002),
      systemNavigationBarDividerColor: Colors.black.withOpacity(0.002),
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark)
  );

//Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  await GetStorage.init();
  setup();
  runApp(const Wodobro());
}

class Wodobro extends StatelessWidget {
  const Wodobro({super.key});

  static const String title = 'Wodobro';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerDelegate: goRouter.routerDelegate,
    routeInformationParser: goRouter.routeInformationParser,
    routeInformationProvider: goRouter.routeInformationProvider,

  );

}

