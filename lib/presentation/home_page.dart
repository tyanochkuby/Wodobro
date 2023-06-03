import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/presentation/tips_page.dart';
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
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            LavaAnimation(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else if (snapshot.hasData) {
                          final user = FirebaseAuth.instance.currentUser;
                          return Text('Hello, ${user!.displayName}!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: Colors.black38));
                        } else
                          return Text('Not logged in');
                      }),
                  FutureBuilder<int>(
                      future: locator
                          .get<DiaryDomainController>()
                          .getTodayHydration(),
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
                                holeLabel:
                                    '${snapshot.data} / ${locator.get<GetStorage>().read('waterForDay')} ml',
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black45, fontWeight: FontWeight.bold)),
            onTap: () {
              setState(() {
                locator.get<DiaryDomainController>().addSip(null, 100, null);
              });
            },
          ),
          SpeedDialChild(
              child: Text('200 ml',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black45, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  locator.get<DiaryDomainController>().addSip(null, 200, null);
                });
              }),
          SpeedDialChild(
              child: Text('500 ml',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black45, fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() {
                  locator.get<DiaryDomainController>().addSip(null, 500, null);
                });
              }),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => TipsPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.lightbulb),
            icon: Icon(Icons.lightbulb_outlined),
            label: 'Tips',
          ),
        ],
      ),
    );
  }
}
