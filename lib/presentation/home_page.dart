import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wodobro/domain/diary_controller.dart';
import 'package:wodobro/application/locator.dart';
import 'package:wodobro/presentation/pages/tips.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:wodobro/presentation/pages/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    Home(),
    TipsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedPageIndex],
      floatingActionButton: selectedPageIndex == 0 ? SpeedDial(
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
      ) : null,
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(66, 165, 245, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            onTabChange: (index) {
              // if (index == 1) {
              //   context.go('/tips');
              // }
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
                GButton(icon: Icons.lightbulb, text: 'Tips'),
              ]),
        ),
      ),
    );
  }
}


