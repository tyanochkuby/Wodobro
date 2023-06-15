import 'dart:async';
import 'dart:math';

import 'package:wodobro/application/locator.dart';
import 'package:wodobro/data/tips_repo.dart';



class TipsDomainController{
  Future<String> getRandomTip() async{
    final _random = new Random();
    final list = await locator.get<TipsRepo>().loadTips();
    return list[_random.nextInt(list.length)];
  }

  getAllTips() async{
    return locator.get<TipsRepo>().loadTips();
  }
}