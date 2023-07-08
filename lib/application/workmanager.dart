import 'package:workmanager/workmanager.dart';
import 'package:wodobro/domain/notification_controller.dart';
import '../domain/temperature_controller.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'schedule_weather_notification_task':
        print('notification task started');
        final double maxTemp = await TemperatureDomainController.getTodayMaxTemperature();
        if (maxTemp > 20) {
          Notifications.showNotification(
            id: 228,
            title: "It's pretty hot today 🥵, ${maxTemp.toString()}°C",
            body: "Don't forget to drink water! 👊",
            payload: 'payload',
          );
        } else {
          Notifications.showNotification(
            title: "Heey, remember about water, bro👊",
          );
        }
        print('task ended');
        return Future.value(true);

        break;
      default:
        return Future.error('workmanager.dart: No such task defined');
    }
    return Future.value(true);
  });
}
