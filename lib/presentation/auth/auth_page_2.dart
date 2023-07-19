import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/application/auth_service.dart';
import 'package:wodobro/domain/position_controller.dart';

import '../../application/locator.dart';
import '../../domain/notification_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 30),
            child: Text('To continue please tap the button below :)',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.black38, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(142, 201, 249, 0.8),
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () async {
              setState(() {});

              User? user = await AuthService.signInWithGoogle(context: context);

              setState(() {});

              if (user != null) {
                print('user signed in');
                final db = FirebaseFirestore.instance;
                final userDocRef = db.collection('diaries').doc(user.uid);
                final doc = await userDocRef.get();
                if (doc.exists) {
                  // Map<String, dynamic>? data = doc.data();
                  // final diary = doc.data()?['diary'];
                  print(doc.data()?['user']);
                  double weight = doc.data()?['user'];
                  locator.get<GetStorage>().write('weight', weight);
                  locator.get<GetStorage>().write('waterForDay', weight * 30);
                  if (await PositionController.checkPermissionGranted()) {
                    if (await Notifications.checkNotificationPermissions()) {
                      locator
                          .get<GetStorage>()
                          .write('initialLocation', '/home');
                      context.go('/home');
                    } else {
                      locator
                          .get<GetStorage>()
                          .write('initialLocation', '/intro/4');
                      context.go('/intro/4');
                    }
                  } else {
                    locator
                        .get<GetStorage>()
                        .write('initialLocation', '/intro/3');
                    context.go('/intro/3');
                  }
                } else
                  context.go('/intro/1');
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('lib/assets/Google_logo.png',
                    height: 20, width: 20),
                const SizedBox(width: 15),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      height: 1.41),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
