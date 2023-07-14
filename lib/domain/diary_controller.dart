import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wodobro/domain/models/diary_entry.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/data/diary_repo.dart';

class DiaryDomainController {
  List<DiaryEntry>? diary = null;

  getDiary() async {
    if (diary != null)
      return diary;
    else {
      diary = await locator<DiaryRepo>().loadDiary();
      return await locator<DiaryRepo>().loadDiary();
    }
  }

  addSip(String? date, int amount, String? time) async {
    diary = await locator<DiaryRepo>()
        .addSip(date == null ? "today" : date, amount, time);
  }

  Future<int> getTodayHydration() async {
    final today = await locator<DiaryDomainController>().getEntryByDay('today');
    //final today = diary.firstWhere((entry) => entry.date == "today", orElse: () => DiaryEntry(date: "today", sips: []));
    final total = today.sips!
        .fold(0, (previousValue, element) => previousValue + element.amount);
    return total;
  }

  Future<int> getHydrationForADay(DateTime day) async {
    final hydration = await locator<DiaryDomainController>()
        .getEntryByDay(DateFormat('yyyy-MM-dd').format(day));
    final total = hydration.sips!
        .fold(0, (previousValue, element) => previousValue + element.amount);
    return total;
  }

  Future<DiaryEntry> getEntryByDay(String date) async {
    if(diary == null) diary = await locator<DiaryRepo>().loadDiary();
    if (date == "today") date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final entry = diary!.firstWhere((entry) => entry.date == date,
        orElse: () => DiaryEntry(date: date, sips: []));
    return entry;
  }

  Future<Map<DateTime, int>> getEntriesByLast30Days() async {
    Map<DateTime, int> last60Days = {};
    final waterForDay = locator.get<GetStorage>().read('waterForDay');
    if(diary == null)
     diary = await locator<DiaryRepo>().loadDiary();
    for (int i = 60; i >= 0; i--) {
      final date = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().subtract(Duration(days: i)));
      DiaryEntry day = diary!.firstWhere((entry) => entry.date == date,
          orElse: () => DiaryEntry(date: date, sips: []));
      int drunkInADay = day.sips!
          .fold(0, (previousValue, element) => previousValue + element.amount);
      int drunkGrade = (drunkInADay / waterForDay * 10).round();
      if (drunkGrade > 10) drunkGrade = 10;
      last60Days[
              DateUtils.dateOnly(DateTime.now().subtract(Duration(days: i)))] =
          drunkGrade;
    }
    return last60Days;
  }
}
