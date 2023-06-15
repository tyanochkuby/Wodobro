import 'dart:convert';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../application/locator.dart';


class TipsRepo {

  Future<List<String>> loadTips() async {
    if (Platform.isAndroid) {
      final tips = locator.get<GetStorage>().read('Tips');
      if (tips == null && FirebaseAuth.instance.currentUser != null) {
        final db = FirebaseFirestore.instance;
        final userDocRef = db.collection('tips').doc('8TYHaFpY5PcfH4aBLHXT');
        final doc = await userDocRef.get();
        if (doc.exists) {
          final returnTips = (doc.data()?['tips']).cast<String>();
          return returnTips;
        } else
          return [];
      }
      else if (tips.runtimeType == List<dynamic>)
        return (jsonDecode(tips) as List<dynamic>)
            .cast<String>();
      else
        return tips;
    } else
      return [];
  }


}
