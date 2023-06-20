import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PositionController extends GetxController {
  Rx<Position> rxPosition = Position.fromMap({'latitude': 0.0, 'longitude': 0.0}).obs;

  Future<Position> getGeoPosition() async {
    var permissionGranted = await checkPermissionGranted();
    if (!permissionGranted) return Position.fromMap({'latitude': 0.0, 'longitude': 0.0});
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    return position;
  }

  Future<bool> checkPermissionGranted() async{
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      return false;
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }
    else
      return false;
  }

  Future<bool> requestPermission() async {
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
      rxPosition.value = newPosition;
    });
  }

  void unsubscribePosition() async {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }
}
