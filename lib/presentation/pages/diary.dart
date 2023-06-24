import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../application/locator.dart';
import '../../domain/diary_controller.dart';

Widget DiaryPage(BuildContext context) {
  return Center(
      child: FutureBuilder<Map<DateTime, int>>(
          future: locator.get<DiaryDomainController>().getEntriesByLast30Days(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 8.0),
                    child: LoadingAnimationWidget.waveDots(
                      color: Colors.white,
                      size: 50,
                    ));
                break;
              default:
                if (snapshot.hasError)
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 8.0),
                      child: Text('Error: ${snapshot.error}'));
                else {
                  return HeatMap(
                    startDate: DateTime.now().subtract(Duration(days: 60)),
                    endDate: DateTime.now(),
                    datasets: snapshot.data!,
                    colorMode: ColorMode.opacity,
                    showText: false,
                    size: 30,
                    scrollable: true,
                    colorsets: {
                      0: Color.fromRGBO(66, 165, 245, 0),
                      1: Color.fromRGBO(66, 165, 245, 0.1),
                      2: Color.fromRGBO(66, 165, 245, 0.2),
                      3: Color.fromRGBO(66, 165, 245, 0.3),
                      4: Color.fromRGBO(66, 165, 245, 0.4),
                      5: Color.fromRGBO(66, 165, 245, 0.5),
                      6: Color.fromRGBO(66, 165, 245, 0.6),
                      7: Color.fromRGBO(66, 165, 245, 0.7),
                      8: Color.fromRGBO(66, 165, 245, 0.8),
                      9: Color.fromRGBO(66, 165, 245, 0.9),
                      10: Color.fromRGBO(66, 165, 245, 1),
                    },
                    onClick: (date) async {
                      int amount = await locator
                          .get<DiaryDomainController>()
                          .getHydrationForADay(date);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'On ${DateFormat('dd/MM/yyyy').format(date)} you drank $amount ml of water',
                          style: GoogleFonts.robotoSlab(
                            color: Colors.white,
                            fontSize: 16,
                          ),)));
                    },
                  );
                }
            }
          }));
}
