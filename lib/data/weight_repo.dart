import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wodobro/domain/diary_controller.dart';

import '../application/locator.dart';

class WeightRepo {
  static Future<int> getWeightOnline() async {
    int weight = 0;
    if (FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      final userDocRef =
          db.collection('diaries').doc(FirebaseAuth.instance.currentUser!.uid);
      final doc = await userDocRef.get();
      if (doc.exists) {
        weight = (doc.data()?['user']);
        return weight;
      } else
        return 0;
    } else
      return weight;
  }

  static Future<void> setWeightOnline(int weight) async {
    final user = FirebaseAuth.instance.currentUser!;
    final db = FirebaseFirestore.instance;
    final diary = await locator.get<DiaryDomainController>().getDiary();
    final List<Map> mapedDiary = [];
    diary.forEach((element) {
      mapedDiary.add(element.toJson());
    });
    final diaryToSave = <String, dynamic>{
      'user': weight,
      'diary': mapedDiary,
    };
    db.collection('diaries').doc(user.uid).set(diaryToSave);
    return;
  }
}
