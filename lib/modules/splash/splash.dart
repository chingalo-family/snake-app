import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snake_app/core/app_state/user_state/user_entry_form_state.dart';
import 'package:snake_app/core/app_state/user_state/user_state.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/core/models/user.dart';
import 'package:snake_app/core/services/user_service.dart';
import 'package:snake_app/modules/game/game.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    setAppThemeAndInitialData();
  }

  setAppThemeAndInitialData() async {
    User? user = await UserService().getCurrentUser();
    setDataForLandingPage(user);
  }

  void setDataForLandingPage(User? user) async {
    if (user != null && user.isLogin) {
      Provider.of<UserState>(context, listen: false).setCurrentUser(user);
    } else {
      Provider.of<UserEntryFormState>(context, listen: false).resetFormState();
    }
    Timer(const Duration(milliseconds: 200), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Game()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.4,
                        width: size.width * 0.3,
                        child: const Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/img/app-icon.png'),
                        ),
                      ),
                      const CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation(
                          AppInfoReference.defaultAppColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
