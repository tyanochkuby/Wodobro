import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage.init();
  final box = GetStorage('test');

  // box.write('Hour', 18);
  // box.write('Minute', 47);
  print('hour: ${box.read('Hour')}, minute: ${box.read('Minute')}');

}