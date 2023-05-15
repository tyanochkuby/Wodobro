import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/domain/models/diary_entry.dart';

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
}
