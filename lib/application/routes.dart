import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:wodobro/locator.dart';

import 'package:wodobro/presentation/intro/intro_page.dart';
import 'package:wodobro/presentation/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  //navigatorKey: _rootNavigatorKey,
  initialLocation: locator.get<GetStorage>().read('initialLocation'),
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
      builder: (context, state) => const HomePage(),
    ),
  ],
);
