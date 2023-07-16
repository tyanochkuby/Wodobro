

import 'package:get_storage/get_storage.dart';
import 'package:wodobro/data/weight_repo.dart';

import '../application/locator.dart';

class WeightDomainController{
  double? weight = null;

  Future<void> setWeight(double newWeight) async{
    weight = newWeight;
    locator.get<GetStorage>().write('weight', weight);
    WeightRepo.setWeight(weight!);
    return;

  }

  Future<double> getWeight() async{
    if(weight == null)
      weight = await WeightRepo.getWeight();
    return weight!;
  }
}