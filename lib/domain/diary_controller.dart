import 'dart:async';

import 'package:wodobro/domain/models/diary_entry.dart';
import 'package:wodobro/locator.dart';
import 'package:wodobro/data/diary_repo.dart';

class DiaryDomainController {
  getDiary() async {
    return await locator<DiaryRepo>().loadDiary();
  }

  addSip(String? date, int amount, String? time) async {
    return await locator<DiaryRepo>()
        .addSip(date == null ? "today" : date, amount, time);
  }

  Future<int> getTodayHydration() async{
    final today = await locator<DiaryRepo>().getEntryByDay('today');
    //final today = diary.firstWhere((entry) => entry.date == "today", orElse: () => DiaryEntry(date: "today", sips: []));
    final total = today.sips!.fold(0, (previousValue, element) => previousValue + element.amount);
    return total;
  }
}
