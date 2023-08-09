import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../application/locator.dart';
import '../../domain/diary_controller.dart';
import '../widgets/lava.dart';

Widget Home() {
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
              FutureBuilder<int>(
                  future:
                      locator.get<DiaryDomainController>().getTodayHydration(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Text('Loading....',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.black38));
                    else {
                      if (snapshot.error != null)
                        return Text('Error: ${snapshot.error}');
                      else {
                        final double drunk = snapshot.data!.toDouble();
                        locator.get<GetStorage>().write('drunk', drunk);
                        return AnimatedCircularChart(
                          key: locator
                              .get<GlobalKey<AnimatedCircularChartState>>(),
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
                                          .read('waterForDay') -
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
                              '${locator.get<GetStorage>().read('drunk')} / ${locator.get<GetStorage>().read('waterForDay')} ml',
                          labelStyle: new TextStyle(
                            color: Colors.blueGrey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        );
                      }
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
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//
//
//   //Future<String> tip = locator.get<TipsDomainController>().getRandomTip();
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           LavaAnimation(
//             child: Column(
//               children: [
//                 SizedBox(height: 50),
//                 StreamBuilder(
//                     stream: FirebaseAuth.instance.authStateChanges(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting)
//                         return Center(child: CircularProgressIndicator());
//                       else if (snapshot.hasError)
//                         return Text('Error: ${snapshot.error}');
//                       else {
//                         //else if //(snapshot.hasData) {
//                         final user = FirebaseAuth.instance.currentUser;
//                         return Text('Hello, ${user!.displayName}!',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium
//                                 ?.copyWith(color: Colors.black38));
//                       } // else
//                       //   return Text('Not logged in');
//                     }),
//                 FutureBuilder<int>(
//                     future: locator
//                         .get<DiaryDomainController>()
//                         .getTodayHydration(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting)
//                         return Text('Loading....');
//                       else {
//                         if (snapshot.error != null)
//                           return Text('Error: ${snapshot.error}');
//                         else {
//                           final double drunk = snapshot.data!.toDouble();
//                           locator.get<GetStorage>().write('drunk', drunk);
//                           return AnimatedCircularChart(
//                             key: locator.get<GlobalKey<AnimatedCircularChartState>>(),
//                             size: Size(300.0, 300.0),
//                             initialChartData: <CircularStackEntry>[
//                               new CircularStackEntry(
//                                 <CircularSegmentEntry>[
//                                   new CircularSegmentEntry(
//                                     drunk,
//                                     Color.fromRGBO(22, 48, 90, 1),
//                                     rankKey: 'completed',
//                                   ),
//                                   new CircularSegmentEntry(
//                                     locator
//                                             .get<GetStorage>()
//                                             .read('waterForDay') -
//                                         drunk,
//                                     Colors.blueGrey[600],
//                                     rankKey: 'remaining',
//                                   ),
//                                 ],
//                               ),
//                             ],
//                             chartType: CircularChartType.Radial,
//                             edgeStyle: SegmentEdgeStyle.round,
//                             holeLabel:
//                                 '${locator.get<GetStorage>().read('drunk')} / ${locator.get<GetStorage>().read('waterForDay')} ml',
//                             labelStyle: new TextStyle(
//                               color: Colors.blueGrey[600],
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24.0,
//                             ),
//                           );
//                         }
//                       }
//                     }),
//               ],
//             ),
//             color: Color.fromRGBO(66, 165, 245, 0.6),
//           ),
//         ],
//       ),
//     );
//   }
// }
