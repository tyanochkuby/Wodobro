import 'package:flutter/material.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

class SettingsPage extends StatelessWidget {
  //const SettingsPage({super.key});

  final TextEditingController weightController = TextEditingController();
  @override
  void initState() {
    weightController.text = ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WodobroTextField(controller: weightController, hintText: 'Enter new weight', keyboardType: keyboardType)
        ],
      ),
    );
  }
}
