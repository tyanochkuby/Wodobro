import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/models/diary_entry.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DiaryRepo {
  Future<void> saveDiary(List<DiaryEntry> diary) async {
    //if (kIsWeb) return;

    if (FirebaseAuth.instance.currentUser != null) {
      final List<Map> mapedDiary =
          []; //= diary.map((e) => e.toJson()).toList();
      diary.forEach((element) {
        mapedDiary.add(element.toJson());
      });

      final user = FirebaseAuth.instance.currentUser!;
      final db = FirebaseFirestore.instance;
      final diaryToSave = <String, dynamic>{
        'user': locator.get<GetStorage>().read('weight'),
        'diary': mapedDiary,
      };
      db.collection('diaries').doc(user.uid).set(diaryToSave);
    }
    locator.get<GetStorage>().write('Diary', diary);
    return;
  }

  Future<List<DiaryEntry>> loadDiary() async {
    if (Platform.isAndroid) {
      final diary = locator.get<GetStorage>().read('Diary');
      if (diary == null) {
        final user = FirebaseAuth.instance.currentUser!;
        final db = FirebaseFirestore.instance;
        final userDocRef = db.collection('diaries').doc(user.uid);
        final doc = await userDocRef.get();
        if (doc.exists) {
          return doc
              .data()?['diary']
              .map<DiaryEntry>((json) => DiaryEntry.fromJson(json))
              .toList();
        } else
          return [];
      } else if (diary.runtimeType == List<dynamic>)
        return diary
            .map<DiaryEntry>((json) => DiaryEntry.fromJson(json))
            .toList();
      else
        return diary;
    }
    if (Platform.isWindows) {
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
    } else
      return [];
  }


  Future<List<DiaryEntry>> addSip(String date, int amount, String? time) async {
    final diary = await loadDiary();
    if (time == null) time = DateFormat('HH:mm').format(DateTime.now());
    if (date == "today") date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final sip = Sip(time: time, amount: amount);
    DiaryEntry entry = diary.firstWhere((entry) => entry.date == date,
        orElse: () => DiaryEntry(date: date, sips: []));
    entry.sips!.add(sip);
    diary.removeWhere((oldEntry) => oldEntry.date == date);
    diary.add(entry);
    await saveDiary(diary);
    return diary;
  }

}
