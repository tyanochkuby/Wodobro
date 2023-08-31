import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/domain/view%20models/homepage_viewmodel.dart';
import 'package:wodobro/presentation/pages/diary.dart';
import 'package:wodobro/presentation/pages/settings.dart';
import 'package:wodobro/presentation/pages/tips.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:wodobro/presentation/pages/home.dart';
import 'package:wodobro/presentation/widgets/lava.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPageIndex = 0;
  bool wasDataCollected = false;
  int additionalWater = 0;
  double drunk = 0;
  final List<Widget> pages = [
    Home(),
    //DiaryPage(),
    TipsPage(),
    SettingsPage(),
  ];
  TextEditingController otherAmountController = TextEditingController();

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
                        !wasDataCollected
                            ? FutureBuilder<List<int>>(
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
                                      wasDataCollected = true;
                                      drunk = snapshot.data![1].toDouble();
                                      locator
                                          .get<GetStorage>()
                                          .write('drunk', drunk);
                                      additionalWater = snapshot.data![0];
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: LavaAnimation(
                                          color:
                                              Color.fromRGBO(66, 165, 245, 0.6),
                                          child: BlurryContainer(
                                            blur: 8,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            elevation: 0,
                                            height: 305,
                                            width: 305,
                                            //padding: EdgeInsets.all(20),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                                                .get<
                                                                    GetStorage>()
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
                                                chartType:
                                                    CircularChartType.Radial,
                                                edgeStyle:
                                                    SegmentEdgeStyle.round,
                                                holeLabel:
                                                    '${drunk.toInt() /*locator.get<GetStorage>().read('drunk')*/} / ${locator.get<GetStorage>().read('waterForDay') + additionalWater} ml',
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
                                })
                            : Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                                Color.fromRGBO(22, 48, 90, 1),
                                                rankKey: 'completed',
                                              ),
                                              new CircularSegmentEntry(
                                                locator
                                                        .get<GetStorage>()
                                                        .read('waterForDay') +
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
                                            '${drunk.toInt() /*locator.get<GetStorage>().read('drunk')*/} / ${locator.get<GetStorage>().read('waterForDay') + additionalWater} ml',
                                        labelStyle: new TextStyle(
                                          color: Colors.blueGrey[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : selectedPageIndex == 1
              ? DiaryPage(context)
              : selectedPageIndex == 2
                  ? TipsPage()
                  : selectedPageIndex == 3
                      ? SettingsPage()
                      : const Text('selectedpageindex Error'),
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
                    child: Text('Other',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                    onTap: () async {
                      int otherAmount = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Enter an amount'),
                                content: TextField(
                                  controller: otherAmountController,
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  decoration:
                                      InputDecoration(hintText: 'Here!'),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(int.parse(
                                            otherAmountController.text));
                                      },
                                      child: const Text('Submit'))
                                ],
                              ));
                      locator
                          .get<DiaryDomainController>()
                          .addSip(null, otherAmount, null);
                      drunk += otherAmount;
                      List<CircularStackEntry> nextData = <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                                (drunk), Color.fromRGBO(22, 48, 90, 1),
                                rankKey: 'completed'),
                            new CircularSegmentEntry(
                                locator.get<GetStorage>().read('waterForDay') -
                                    drunk,
                                Colors.blueGrey[600],
                                rankKey: 'remaining'),
                          ],
                          rankKey: 'Quarterly Profits',
                        ),
                      ];
                      setState(() {
                        locator.get<GetStorage>().write('drunk', drunk);
                        locator
                            .get<GlobalKey<AnimatedCircularChartState>>()
                            .currentState
                            ?.updateData(nextData);
                      });
                    }),
                SpeedDialChild(
                  child: Text('100 ml',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black45, fontWeight: FontWeight.bold)),
                  onTap: () {
                    locator
                        .get<DiaryDomainController>()
                        .addSip(null, 100, null);
                    drunk += 100;
                    List<CircularStackEntry> nextData = <CircularStackEntry>[
                      new CircularStackEntry(
                        <CircularSegmentEntry>[
                          new CircularSegmentEntry(
                              (drunk), Color.fromRGBO(22, 48, 90, 1),
                              rankKey: 'completed'),
                          new CircularSegmentEntry(
                              locator.get<GetStorage>().read('waterForDay') -
                                  drunk,
                              Colors.blueGrey[600],
                              rankKey: 'remaining'),
                        ],
                        rankKey: 'Quarterly Profits',
                      ),
                    ];
                    setState(() {
                      locator.get<GetStorage>().write('drunk', drunk);
                      locator
                          .get<GlobalKey<AnimatedCircularChartState>>()
                          .currentState
                          ?.updateData(nextData);
                    });
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
                      drunk += 200;
                      List<CircularStackEntry> nextData = <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                                (drunk), Color.fromRGBO(22, 48, 90, 1),
                                rankKey: 'completed'),
                            new CircularSegmentEntry(
                                locator.get<GetStorage>().read('waterForDay') -
                                    drunk,
                                Colors.blueGrey[600],
                                rankKey: 'remaining'),
                          ],
                          rankKey: 'Quarterly Profits',
                        ),
                      ];
                      setState(() {
                        locator.get<GetStorage>().write('drunk', drunk);
                        locator
                            .get<GlobalKey<AnimatedCircularChartState>>()
                            .currentState
                            ?.updateData(nextData);
                      });
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
                      drunk += 500;
                      List<CircularStackEntry> nextData = <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                                (drunk), Color.fromRGBO(22, 48, 90, 1),
                                rankKey: 'completed'),
                            new CircularSegmentEntry(
                                locator.get<GetStorage>().read('waterForDay') -
                                    drunk,
                                Colors.blueGrey[600],
                                rankKey: 'remaining'),
                          ],
                          rankKey: 'Quarterly Profits',
                        ),
                      ];
                      setState(() {
                        locator.get<GetStorage>().write('drunk', drunk);

                        locator
                            .get<GlobalKey<AnimatedCircularChartState>>()
                            .currentState
                            ?.updateData(nextData);
                      });
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
                GButton(icon: Icons.settings, text: 'Settings'),
              ]),
        ),
      ),
    );
  }
}
