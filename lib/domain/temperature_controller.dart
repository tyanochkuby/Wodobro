import 'dart:convert';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:http/http.dart' as http;
import 'package:wodobro/application/locator.dart';
import 'package:workmanager/workmanager.dart';


class TemperatureDomainController extends GetxController {
  RxDouble maxDayTemperature = 0.0.obs;

  Future<double> getTodayMaxTemperature() async {
    http.Client client = http.Client();

    final response = await client.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=52.41&longitude=16.93&daily=temperature_2m_max&forecast_days=1&timezone=Europe%2FBerlin'));
    Map<String, dynamic> forecastMap = json.decode(response.body);
    double maxTemp = forecastMap['daily']['temperature_2m_max'][0];
    return maxTemp;
  }




}
