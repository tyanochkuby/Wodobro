

import 'package:workmanager/workmanager.dart';
import 'package:wodobro/domain/notification_controller.dart';
import '../domain/temperature_controller.dart';
import 'package:wodobro/application/locator.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    switch(taskName){
      case 'schedule_weather_notification_task':
        locator.get<TemperatureDomainController>().getTodayMaxTemperature().then((value) {
          Notifications.showNotification(
            title: "It's pretty hot today 🥵, ${value.toString()}°C",
            body: "Don't forget to drink water!",
          );
        });
        break;
      default:
    }
    return Future.value(true);
  });
}