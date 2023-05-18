import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/domain/models/diary_entry.dart';
import 'package:intl/intl.dart';

class DiaryRepo {
  Future<void> saveDiary(List<DiaryEntry> diary) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/.wodobro/diary.json');
    await file.writeAsString(jsonEncode(diary));
  }

  Future<List<DiaryEntry>> loadDiary() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/.wodobro/diary.json');
    if (await file.exists()) {
      final diary = jsonDecode(await file.readAsString());
      return diary
          .map<DiaryEntry>((json) => DiaryEntry.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  Future<void> addSip(String date, int amount, String? time) async {
    final diary = await loadDiary();
    if (time == null) time = DateFormat('HH:mm').format(DateTime.now());
    if (date == "today") date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sip = Sip(time: time, amount: amount);
    final entry = diary.firstWhere((entry) => entry.date == date,
        orElse: () => DiaryEntry(date: date, sips: []));
    entry.sips!.add(sip);
    diary.removeWhere((entry) => entry.date == date);
    diary.add(entry);
    await saveDiary(diary);
  }
}
