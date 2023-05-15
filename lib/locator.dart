import 'package:get_it/get_it.dart';
import 'package:wodobro/data/diary_repo.dart';
import 'package:wodobro/domain/diary_controller.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerLazySingleton<DiaryRepo>(() => DiaryRepo());
  locator.registerLazySingleton<DiaryDomainController>(
      () => DiaryDomainController());
}
