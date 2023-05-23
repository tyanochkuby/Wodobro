import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wodobro/presentation/widgets/big_bottom_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: Column(
            children: [
              Text('Let\'s authenticate',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.black38, fontWeight: FontWeight.bold)),
              const SizedBox(height: 26),
              ElevatedButton(
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
            ],
          ),
        ),
      ),
    ));
  }
}
