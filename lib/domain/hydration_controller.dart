import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/temperature_controller.dart';

class HydrationController{
  void estimateTodayHydration() async{
    if(locator.get<GetStorage>().read('additionalWater') == null || locator.get<GetStorage>().read('lastTimeEstimated') != DateUtils.dateOnly(DateTime.now())) {
      final double maxTemperature = await TemperatureDomainController.getTodayMaxTemperature();
      if(maxTemperature > 15)
        locator.get<GetStorage>().write('additionalWater', ((maxTemperature-15).floor() * 40));
      else
        locator.get<GetStorage>().write('additionalWater', 0);
      locator.get<GetStorage>().write('lastTimeEstimated', DateUtils.dateOnly(DateTime.now()));
      return;
    }
  }
}