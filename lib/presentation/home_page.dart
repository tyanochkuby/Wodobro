import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wodobro/data/diary_repo.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/presentation/widgets/add_close_animatedicon.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:wodobro/presentation/widgets/lava.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//class HomePage extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  // late Future<int> drinkToday;
  // late Future<int> waterRemained;
  // late double waterRemained;
  //
  // getDrinkToday() async{
  //   drinkToday = await locator.get<DiaryDomainController>().getTodayHydration();
  //   return drinkToday;
  // }
  //
  //@override
  // void initState() {
  //   super.initState();
  //   drinkToday = locator.get<DiaryDomainController>().getTodayHydration();
  //   waterRemained = locator.get<GetStorage>().read('waterForDay') - drinkToday;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              LavaAnimation(
                child: Column(
                  children: [
                    Text('Home Page',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.black38)),
                    FutureBuilder<int>(
                        future:
                            locator.get<DiaryDomainController>().getTodayHydration(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Text('Loading....');
                            default:
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else
                                return AnimatedCircularChart(
                                    key: _chartKey,
                                    size: Size(300.0, 300.0),
                                    initialChartData: <CircularStackEntry>[
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            snapshot.data!.toDouble(),
                                            Color.fromRGBO(22, 48, 90, 1),
                                            rankKey: 'completed',
                                          ),
                                          new CircularSegmentEntry(
                                            locator
                                                    .get<GetStorage>()
                                                    .read('waterForDay') -
                                                snapshot.data!.toDouble(),
                                            Colors.blueGrey[600],
                                            rankKey: 'remaining',
                                          ),
                                        ],
                                      ),
                                    ],
                                    chartType: CircularChartType.Radial,
                                    edgeStyle: SegmentEdgeStyle.round,
                                    holeLabel: '${snapshot.data} / ${locator.get<GetStorage>().read('waterForDay')} ml',
                                    labelStyle: new TextStyle(
                                      color: Colors.blueGrey[600],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  );
                          }
                        }),
                  ],
                ),
                  color: Color.fromRGBO(66, 165, 245, 0.6),
              ),
              // new AnimatedCircularChart(
              //   key: _chartKey,
              //   size: Size(300.0, 300.0),
              //   initialChartData: <CircularStackEntry>[
              //     new CircularStackEntry(
              //       <CircularSegmentEntry>[
              //         new CircularSegmentEntry(
              //           drinkToday,
              //           //200,
              //           Colors.blue[400],
              //           rankKey: 'completed',
              //         ),
              //         new CircularSegmentEntry(
              //           waterRemained,
              //           Colors.blueGrey[600],
              //           rankKey: 'remaining',
              //         ),
              //       ],
              //       rankKey: 'progress',
              //     ),
              //   ],
              //   chartType: CircularChartType.Radial,
              //   percentageValues: true,
              // )
            ],
          ),
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          overlayColor: Colors.black,
          overlayOpacity: 0.3,
          elevation: 10.0,
          buttonSize: Size(100.0, 100.0),
          childrenButtonSize: Size(80.0, 80.0),
          children: [
            SpeedDialChild(
              child: Text('100 ml',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black45, fontWeight: FontWeight.bold)),
              onTap: () {
                setState((){
                  locator.get<DiaryDomainController>().addSip(null, 100, null);
                });
              },
            ),
            SpeedDialChild(
                child: Text('200 ml',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black45, fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() {
                    locator.get<DiaryDomainController>().addSip(null, 200, null);
                  });
                }),
            SpeedDialChild(
                child: Text('500 ml',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.black45, fontWeight: FontWeight.bold)),
                onTap: () {
                  setState(() {
                    locator.get<DiaryDomainController>().addSip(null, 500, null);
                  });
                }),
          ],
        ));
  }
}
