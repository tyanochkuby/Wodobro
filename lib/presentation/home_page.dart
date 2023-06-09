import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/hydration_controller.dart';
import 'package:wodobro/domain/view%20models/homepage_viewmodel.dart';
import 'package:wodobro/presentation/pages/diary.dart';
import 'package:wodobro/presentation/pages/tips.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:wodobro/presentation/pages/home.dart';
import 'package:wodobro/presentation/widgets/lava.dart';

import '../domain/notification_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    Home(),
    //DiaryPage(),
    TipsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          selectedPageIndex == 1 ? Colors.blueGrey[200] : Colors.white,
      body: selectedPageIndex == 0
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 600,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        StreamBuilder(
                            stream: FirebaseAuth.instance.authStateChanges(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 8.0),
                                    child: LoadingAnimationWidget.waveDots(
                                      color: Colors.white,
                                      size: 50,
                                    ));
                              else if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              else {
                                //else if //(snapshot.hasData) {
                                final user = FirebaseAuth.instance.currentUser;
                                return Text('Hello, ${user!.displayName}!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(color: Colors.black38));
                              } // else
                              //   return Text('Not logged in');
                            }),
                        FutureBuilder<List<int>>(
                            future: HomePageViewModel().homePageViewModel(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 8.0),
                                  child: LoadingAnimationWidget.waveDots(
                                    color: Colors.white,
                                    size: 50,
                                  ));
                              else {
                                if (snapshot.error != null)
                                  return Text('Error: ${snapshot.error}');
                                else {
                                  final double drunk =
                                      snapshot.data![1].toDouble();
                                  locator
                                      .get<GetStorage>()
                                      .write('drunk', drunk);
                                  final int additionalWater = snapshot.data![0];
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: LavaAnimation(
                                      color: Color.fromRGBO(66, 165, 245, 0.6),
                                      child: BlurryContainer(
                                        blur: 8,
                                        borderRadius: BorderRadius.circular(50),
                                        elevation: 0,
                                        height: 305,
                                        width: 305,
                                        //padding: EdgeInsets.all(20),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: AnimatedCircularChart(
                                            key: locator.get<
                                                GlobalKey<
                                                    AnimatedCircularChartState>>(),
                                            size: Size(300.0, 300.0),
                                            initialChartData: <CircularStackEntry>[
                                              new CircularStackEntry(
                                                <CircularSegmentEntry>[
                                                  new CircularSegmentEntry(
                                                    drunk,
                                                    Color.fromRGBO(
                                                        22, 48, 90, 1),
                                                    rankKey: 'completed',
                                                  ),
                                                  new CircularSegmentEntry(
                                                    locator
                                                            .get<GetStorage>()
                                                            .read(
                                                                'waterForDay') +
                                                        additionalWater -
                                                        drunk,
                                                    Colors.blueGrey[600],
                                                    rankKey: 'remaining',
                                                  ),
                                                ],
                                              ),
                                            ],
                                            chartType: CircularChartType.Radial,
                                            edgeStyle: SegmentEdgeStyle.round,
                                            holeLabel:
                                                '${drunk.toInt()/*locator.get<GetStorage>().read('drunk')*/} / ${locator.get<GetStorage>().read('waterForDay') + additionalWater} ml',
                                            labelStyle: new TextStyle(
                                              color: Colors.blueGrey[600],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : selectedPageIndex == 1
              ? DiaryPage(context)
              : TipsPage(),
      floatingActionButton: selectedPageIndex == 0
          ? SpeedDial(
              icon: Icons.add,
              overlayColor: Colors.black,
              overlayOpacity: 0.3,
              elevation: 10.0,
              buttonSize: Size(100.0, 100.0),
              childrenButtonSize: Size(80.0, 80.0),
              children: [
                SpeedDialChild(
                  child: Text('100 ml',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black45, fontWeight: FontWeight.bold)),
                  onTap: () {
                    locator
                        .get<DiaryDomainController>()
                        .addSip(null, 100, null);
                    double drunk = locator.get<GetStorage>().read('drunk');
                    List<CircularStackEntry> nextData = <CircularStackEntry>[
                      new CircularStackEntry(
                        <CircularSegmentEntry>[
                          new CircularSegmentEntry(
                              (drunk + 100.0), Color.fromRGBO(22, 48, 90, 1),
                              rankKey: 'completed'),
                          new CircularSegmentEntry(
                              locator.get<GetStorage>().read('waterForDay') -
                                  drunk -
                                  100.0,
                              Colors.blueGrey[600],
                              rankKey: 'remaining'),
                        ],
                        rankKey: 'Quarterly Profits',
                      ),
                    ];
                    setState(() {
                      locator.get<GetStorage>().write('drunk', drunk + 100.0);
                      locator
                          .get<GlobalKey<AnimatedCircularChartState>>()
                          .currentState
                          ?.updateData(nextData);
                    });
                    setState(() {});
                  },
                ),
                SpeedDialChild(
                    child: Text('200 ml',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      locator
                          .get<DiaryDomainController>()
                          .addSip(null, 200, null);
                      double drunk = locator.get<GetStorage>().read('drunk');
                      List<CircularStackEntry> nextData = <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                                (drunk + 200.0), Color.fromRGBO(22, 48, 90, 1),
                                rankKey: 'completed'),
                            new CircularSegmentEntry(
                                locator.get<GetStorage>().read('waterForDay') -
                                    drunk -
                                    200.0,
                                Colors.blueGrey[600],
                                rankKey: 'remaining'),
                          ],
                          rankKey: 'Quarterly Profits',
                        ),
                      ];
                      setState(() {
                        locator.get<GetStorage>().write('drunk', drunk + 200.0);
                        locator
                            .get<GlobalKey<AnimatedCircularChartState>>()
                            .currentState
                            ?.updateData(nextData);
                      });
                      setState(() {});
                    }),
                SpeedDialChild(
                    child: Text('500 ml',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                    onTap: () {
                      locator
                          .get<DiaryDomainController>()
                          .addSip(null, 500, null);
                      double drunk = locator.get<GetStorage>().read('drunk');
                      List<CircularStackEntry> nextData = <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                                (drunk + 500.0), Color.fromRGBO(22, 48, 90, 1),
                                rankKey: 'completed'),
                            new CircularSegmentEntry(
                                locator.get<GetStorage>().read('waterForDay') -
                                    drunk -
                                    500.0,
                                Colors.blueGrey[600],
                                rankKey: 'remaining'),
                          ],
                          rankKey: 'Quarterly Profits',
                        ),
                      ];
                      setState(() {
                        locator.get<GetStorage>().write('drunk', drunk + 500.0);
                        locator
                            .get<GlobalKey<AnimatedCircularChartState>>()
                            .currentState
                            ?.updateData(nextData);
                      });
                      setState(() {});
                    }),
              ],
            )
          : null,
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(66, 165, 245, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              onTabChange: (index) {
                setState(() {
                  selectedPageIndex = index;
                });
              },
              padding: EdgeInsets.all(16),
              gap: 8,
              backgroundColor: const Color.fromRGBO(66, 165, 245, 1),
              color: Colors.white70,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromRGBO(2, 0, 117, 1.0),
              selectedIndex: selectedPageIndex,
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.book, text: 'Diary'),
                GButton(icon: Icons.lightbulb, text: 'Tips'),
              ]),
        ),
      ),
    );
  }
}
