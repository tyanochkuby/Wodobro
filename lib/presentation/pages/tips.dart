import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/application/locator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wodobro/domain/tips_controller.dart';
import 'package:wodobro/presentation/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  //const TipsPage({Key? key}) : super(key: key);
  Future<String> tip = locator.get<TipsDomainController>().getRandomTip();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          SizedBox(
            width: double.infinity,
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Here\'s your tip for today:',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.black38)),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: FutureBuilder<String>(
                    future:
                        tip, //locator.get<TipsDomainController>().getRandomTip(),
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
                        default:
                          if (snapshot.hasError)
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 8.0),
                                child: Text('Error: ${snapshot.error}'));
                          else
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 8.0),
                              child: Text(
                                '${snapshot.data!}',
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.black87,
                                  fontSize: 35,
                                ),
                              ),
                            );
                      }
                    }),
              ),
            ),
          ),
          SizedBox(height: 30),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58.0, vertical: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    tip = locator.get<TipsDomainController>().getRandomTip();
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                  child: Text(
                    'Next tip',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color.fromRGBO(245, 245, 247, 0.9),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: Colors.white,
          //     backgroundColor: Color.fromRGBO(66, 165, 245, 0.8),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(32.0),
          //     ),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       tip = locator.get<TipsDomainController>().getRandomTip();
          //     });
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Text(
          //       'Next tip',
          //       style: TextStyle(fontSize: 30),
          //     ),
          //   ),
          // )
        ]));
  }
}
