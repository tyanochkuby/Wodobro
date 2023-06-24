import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PositionController extends GetxController {
  Rx<Position> rxPosition = Position.fromMap({'latitude': 0.0, 'longitude': 0.0}).obs;

  static Future<Position> getGeoPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position? position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);//await Geolocator.getLastKnownPosition(); //Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    if (position != null)
      return position;
    else
      return Position(longitude: 0.0, latitude: 0.0, timestamp: null, accuracy: 0.0, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);
    return Position.fromMap({'longitude': 16.92, 'latitude': 52.41});
  }

  static Future<bool> checkPermissionGranted() async{
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied || permission == LocationPermission.unableToDetermine) {
      return false;
    } else if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    }
    else
      return false;
  }

  static Future<bool> requestPermission() async {
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
