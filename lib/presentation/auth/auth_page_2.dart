import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/application/auth_service.dart';

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
        child: Center(
          child: Text('Register Page'),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12),
          child: ElevatedButton(
            onPressed: () async {
              setState(() {});

              User? user = await AuthService.signInWithGoogle(context: context);

              setState(() {});

              if (user != null) {
                print('user signed in');
                context.go('/home');
              }
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(6.0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
            ),
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
