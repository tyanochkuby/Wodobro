import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/domain/hydration_controller.dart';
import 'package:wodobro/domain/models/diary_entry.dart';

class HomePageViewModel
{
  Future<List<int>> homePageViewModel() async{
    final int additionalWater = await HydrationController.estimateTodayHydration();
    final int todayHydration = await locator.get<DiaryDomainController>().getTodayHydration();
    return [additionalWater, todayHydration];
  }
}

