import 'dart:convert';

import 'package:http/http.dart' as http;

main() async {
  http.Client client = http.Client();
  double longitude = 52.40;
  double latitude = 16.92;
  final String url = 'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max&forecast_days=1&timezone=Europe%2FBerlin';
  final response = await client.get(Uri.parse(url));
  Map<String, dynamic> forecastMap = await json.decode(response.body);
  double maxTemp = forecastMap['daily']['temperature_2m_max'][0];
  print(maxTemp);
}