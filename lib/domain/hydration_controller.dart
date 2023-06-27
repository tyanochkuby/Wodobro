import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/temperature_controller.dart';

class HydrationController{
  static Future<int> estimateTodayHydration() async{
    if(locator.get<GetStorage>().read('lastTimeEstimated') != DateUtils.dateOnly(DateTime.now())) {
      final double maxTemperature = await TemperatureDomainController.getTodayMaxTemperature();
      if(maxTemperature > 15) {
        locator.get<GetStorage>().write(
            'lastTimeEstimated', DateUtils.dateOnly(DateTime.now()));
        final int additionalWater = (maxTemperature - 15).floor() * 40;
        locator.get<GetStorage>().write('additionalWater', additionalWater);
        return additionalWater;
      }
      else {
        locator.get<GetStorage>().write(
            'lastTimeEstimated', DateUtils.dateOnly(DateTime.now()));
        locator.get<GetStorage>().write('additionalWater', 0);
        return 0;
      }
    }
    else{
      return locator.get<GetStorage>().read('additionalWater');
    }
  }
}