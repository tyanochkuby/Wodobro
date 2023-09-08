import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/position_controller.dart';
import 'package:wodobro/presentation/widgets/lava.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 50),
                Expanded(
                  child: Column(
                    children: [
                      AutoSizeText('Now, we need to know your location',
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      AutoSizeText(
                        'This way we can calculate the amount of water you need to drink today',
                        maxFontSize: 38,
                        maxLines: 5,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Colors.black38),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 55),
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
          onPressed: () async {
            if (!await PositionController.requestPermission()) {
              locator
                  .get<GetStorage>()
                  .write('isLocationPermissionGranted', false);
            } else
              locator
                  .get<GetStorage>()
                  .write('isLocationPermissionGranted', true);

            context.go('/intro/4');
          },
          child: Text(
            'Sure! Ask me for permission',
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
