
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/domain/diary_controller.dart';

import '../application/locator.dart';

class WeightRepo{
  Future<double> getWeight() async{
    final tips = locator.get<GetStorage>().read('weight');
    if (tips == null && FirebaseAuth.instance.currentUser != null) {
      final db = FirebaseFirestore.instance;
      final userDocRef = db.collection('diaries').doc(FirebaseAuth.instance.currentUser!.uid);
      final doc = await userDocRef.get();
      if (doc.exists) {
        final weight = (doc.data()?['user']).cast<double>();
        return weight;
      } else
        return 0.0;
    }
    else return 0.0;
  }

  Future<void> setWeight(double weight) async{
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
    locator.get<GetStorage>().write('weight', weight);
    return;
  }
}