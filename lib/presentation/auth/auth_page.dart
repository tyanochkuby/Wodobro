import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/presentation/widgets/lava.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LavaAnimation(
        color: Color.fromRGBO(142, 201, 249, 1),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              child: Column(
                children: [
                  Text('Welcome to Wodobro',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold)),
                  SizedBox(height: 26),
                  Text(
                      'In order to use this app, you need to sign in with your Google account',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.black38, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () {
              context.push('/auth/2');
            },
            child: Text(
              'Next',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color.fromRGBO(245, 245, 247, 0.9),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
