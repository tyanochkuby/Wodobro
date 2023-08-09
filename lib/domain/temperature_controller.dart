import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:wodobro/domain/position_controller.dart';

class TemperatureDomainController {
  static Future<double> getTodayMaxTemperature() async {
    http.Client client = http.Client();

    Position position = await PositionController.getGeoPosition();
    double longitude = double.parse((position.longitude).toStringAsFixed(2));
    double latitude = double.parse((position.latitude).toStringAsFixed(2));
    final String url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max&forecast_days=1&timezone=Europe%2FBerlin';
    final response = await client.get(Uri.parse(url));
    print(response.body);
    Map<String, dynamic> forecastMap = json.decode(response.body);
    double maxTemp = forecastMap['daily']['temperature_2m_max'][0];
    return maxTemp;
  }
}
