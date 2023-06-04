import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../application/locator.dart';
import '../../domain/diary_controller.dart';
import '../widgets/lava.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
//class HomePage extends StatelessWidget {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
  new GlobalKey<AnimatedCircularChartState>();

  @override
  Widget build(BuildContext context) {
    return Center(
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
      );
  }
}