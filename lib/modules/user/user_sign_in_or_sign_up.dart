import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/components/material_card.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/user/components/sign_in_or_sign_up_container.dart';

class UserSignInOrSignUp extends StatelessWidget {
  const UserSignInOrSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.shortestSide * 0.25,
                width: size.shortestSide * 0.25,
                child: const Image(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/img/app-icon.png'),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  AppInfoReference.appName,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Sign in to play and complete on the leaderboard!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: MaterialCard(
                  body: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16.0),
                    child: const SignInOrSignUpContainer(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
