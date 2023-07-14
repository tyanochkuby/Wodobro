import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wodobro/domain/weight_controller.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

import '../../application/locator.dart';

class SettingsPage extends StatelessWidget {
  //const SettingsPage({super.key});

  final TextEditingController weightController = TextEditingController();
  @override
  void initState() {
    weightController.text =
        locator.get<WeightDomainController>().getWeight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WodobroTextField(
            controller: weightController,
            hintText: 'Enter new weight',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[\d]"))
            ],
          ),
          ElevatedButton(
            onPressed: () {
              locator
                  .get<WeightDomainController>()
                  .setWeight(double.parse(weightController.text));
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }
}
