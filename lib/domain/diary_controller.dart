import 'package:wodobro/locator.dart';
import 'package:wodobro/data/diary_repo.dart';

class DiaryDomainController {
  getDiary() async {
    return await locator<DiaryRepo>().loadDiary();
  }

  addSip(String? date, int amount, String? time) async{
    return await locator<DiaryRepo>().addSip(date == null ? "today" : date, amount, time);
  }
}