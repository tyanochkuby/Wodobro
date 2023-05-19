import 'dart:math';

import 'package:flutter/material.dart';

class AddCloseAnimatedIcon extends StatefulWidget {
  @override
  _AddCloseAnimatedIconState createState() => _AddCloseAnimatedIconState();
}

class _AddCloseAnimatedIconState extends State<AddCloseAnimatedIcon> with SingleTickerProviderStateMixin {
  late AnimationController animatedController;
  double _angle = 0;

  @override
  void initState() {
    animatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animatedController.addListener(() {
      setState(() {
        _angle = animatedController.value * 45 / 360 * pi * 2;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
              child: InkResponse(
                onTap: () {
                  if (animatedController.status == AnimationStatus.completed)
                    animatedController.reverse();
                  else if (animatedController.status == AnimationStatus.dismissed)
                    animatedController.forward();
                },
                child: Transform.rotate(
                  angle: _angle,
                  child: Icon(
                    Icons.add,
                    size: 50,
                  ),
                ),
              ),
            )));
  }
}