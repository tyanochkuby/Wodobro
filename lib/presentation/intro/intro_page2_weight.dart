import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/domain/cubit/settings_cubit.dart';
import 'package:wodobro/presentation/widgets/lava.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

class IntroPage2 extends StatefulWidget {
  const IntroPage2({super.key});

  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  Widget build(BuildContext context) {
    final weightController = TextEditingController(
        text:
            context.watch<SettingsCubit>().state.userWeight?.toString() ?? '');
    return Scaffold(
      body: LavaAnimation(
        color: Color.fromRGBO(142, 201, 249, 1),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(left: 11.0, right: 11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('First, we need to know your weight',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: Colors.black38)),
                ),
                const SizedBox(height: 55),
                SizedBox(
                  child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, state) {
                      return WodobroTextField(
                        controller: weightController,
                        hintText: 'Enter your weight',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[\d]")),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          onPressed: () {
            setState(() {
              if (!weightController.text.isEmpty) {
                BlocProvider.of<SettingsCubit>(context)
                    .setWeight(int.parse(weightController.text));
                context.push('/intro/3');
              }
            });
          },
          child: Text(
            'Save weight',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color.fromRGBO(245, 245, 247, 0.9),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      )),
    );
  }
}
