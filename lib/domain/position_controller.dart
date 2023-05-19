import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PositionController extends GetxController {
  final positionString = ''.obs;

  Future<void> getGeoPosition() async {
    var permissionGranted = await checkPermissionGranted();
    if (!permissionGranted) return;
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    positionString.value = position.toString();
  }

  Future<bool> checkPermissionGranted() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        Get.snackbar('No permission was granted', 'Cannot get position');
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  StreamSubscription<Position>? _positionStreamSubscription;

  void subscribePosition() async {
    var permissionGranted = await checkPermissionGranted();
    if (!permissionGranted) return;

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        distanceFilter: 1000,
      ),
    ).listen((Position newPosition) {
      positionString.value = newPosition.toString();
    });
  }

  void unsubscribePosition() async {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
}
