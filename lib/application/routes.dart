import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:wodobro/application/locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wodobro/presentation/auth/auth_page.dart';
import 'package:wodobro/presentation/auth/auth_page_2.dart';
import 'dart:io' show Platform;

import 'package:wodobro/presentation/intro/intro_page.dart';
import 'package:wodobro/presentation/intro/intro_page2.dart';
import 'package:wodobro/presentation/intro/intro_page3.dart';
import 'package:wodobro/presentation/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  //navigatorKey: _rootNavigatorKey,
  initialLocation: (kIsWeb) ? '/auth/1' : (locator.get<GetStorage>().read('userIsLoggedIn') ? locator.get<GetStorage>().read('initialLocation') : 'auth/1'),
  observers: [HeroController()],
  routes: [
    GoRoute(
      name: 'intro_1',
      path: '/intro/1',
      builder: (context, state) => const IntroPage1(),
    ),
    GoRoute(
      name: 'intro_2',
      path: '/intro/2',
      builder: (context, state) => IntroPage2(),
    ),
    GoRoute(
        name: 'intro_3',
        path: '/intro/3',
        builder: (context, state) => IntroPage3()),
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => HomePage()),
    GoRoute(
      name: 'auth_start',
      path: '/auth/1',
      builder: (context, state) => const AuthPage(),),
    GoRoute(
      name: 'auth',
      path: '/auth/2',
      builder: (context, state) => const RegisterPage(),),

  ],
);
