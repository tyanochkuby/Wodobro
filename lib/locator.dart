import 'package:get_it/get_it.dart';
import 'package:wodobro/data/diary_repo.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/position_controller.dart';

final locator = GetIt.instance;

final box = GetStorage();

void setup() {
  box.writeIfNull('initialLocation', '/intro/1');
  locator.registerLazySingleton<DiaryRepo>(() => DiaryRepo());
  locator.registerLazySingleton<DiaryDomainController>(
      () => DiaryDomainController());
  locator.registerLazySingleton<GetStorage>(() => box);
  locator.registerLazySingleton<PositionController>(() => PositionController());
}
