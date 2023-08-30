import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/data/diary_repo.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/hydration_controller.dart';
import 'package:wodobro/domain/position_controller.dart';
import 'package:wodobro/data/tips_repo.dart';
import 'package:wodobro/domain/tips_controller.dart';
import 'package:wodobro/domain/weight_controller.dart';
import 'auth_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final locator = GetIt.instance;

final box = GetStorage();

void setup() async {
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  if (defaultTargetPlatform == TargetPlatform.windows)
    box.writeIfNull('initialLocation', '/intro/1');
  else {
    if (FirebaseAuth.instance.currentUser != null) {
      box.writeIfNull('initialLocation', '/home');
    } else
      box.writeIfNull('initialLocation', '/auth/1');
  }
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  //box.write('waterForDay', 2000);
  AuthService.handleAuthState();
  locator.registerLazySingleton<DiaryRepo>(() => DiaryRepo());
  locator.registerLazySingleton<TipsRepo>(() => TipsRepo());
  locator.registerLazySingleton<DiaryDomainController>(
      () => DiaryDomainController());
  locator.registerLazySingleton<TipsDomainController>(
      () => TipsDomainController());
  locator.registerLazySingleton<WeightDomainController>(
      () => WeightDomainController());
  locator.registerLazySingleton<GetStorage>(() => box);
  locator.registerLazySingleton<PositionController>(() => PositionController());
  locator
      .registerLazySingleton<HydrationController>(() => HydrationController());
  locator.registerLazySingleton<GlobalKey<AnimatedCircularChartState>>(
      () => _chartKey);
}
