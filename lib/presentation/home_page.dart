import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/locator.dart';
import 'package:wodobro/presentation/widgets/add_close_animatedicon.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:wodobro/locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text('Home Page',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.black38)),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          children: [
            SpeedDialChild(
              child: Text('100 ml',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black45)),
              onTap: () {
                locator.get<DiaryDomainController>().addSip(null, 100, null);
              },
            ),
            SpeedDialChild(
                child: Text('200 ml',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black45)),
                onTap: () {
                  locator.get<DiaryDomainController>().addSip(null, 200, null);
                }
            ),
            SpeedDialChild(
                child: Text('500 ml',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.black45)),
              onTap: () {
                locator.get<DiaryDomainController>().addSip(null, 500, null);
              }
            ),
          ],
        ));
  }
}
