import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/locator.dart';
import 'dart:io';
import 'package:wodobro/application/routes.dart';


void main() async{
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

