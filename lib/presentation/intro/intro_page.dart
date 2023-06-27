import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/presentation/widgets/lava.dart';
import 'package:wodobro/presentation/widgets/wodobro_text_field.dart';

import 'package:wodobro/domain/position_controller.dart';
import 'package:wodobro/application/routes.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/presentation/widgets/lava_painter.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LavaAnimation(
        color: Theme.of(context).colorScheme.primary,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.only(left: 11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wodobro',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: const Color.fromRGBO(142, 201, 249, 1),
                        fontWeight: FontWeight.bold)),
                Text('A simply way to track your water intake',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.black38)),
                const SizedBox(height: 26),
                Column(
                  children: [
                    ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(2, 0, 117, 1.0),
                      ),
                      dense: true,
                      title: Text(
                        'Track your water intake',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(2, 0, 117, 1.0),
                      ),
                      dense: true,
                      title: Text(
                        'Get reminders to drink water based on your location',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.check_circle,
                        color: Color.fromRGBO(2, 0, 117, 1.0),
                      ),
                      dense: true,
                      title: Text(
                        'Add widget to your home screen',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  ],
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
            context.go('/intro/2');
          },
          child: Text(
            'Get Started',
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



