import 'package:flutter/material.dart';
import 'package:snake_app/core/components/app_bar_container.dart';
import 'package:snake_app/core/constants/app_info_reference.dart';
import 'package:snake_app/modules/about/components/about_detail.dart';
import 'package:snake_app/modules/about/components/about_icon.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      AboutIcon(size: size),
                      const AboutDetail(
                        textColor: AppInfoReference.defaultAppColor,
                        value: 'App Name : ${AppInfoReference.appName}',
                      ),
                      const AboutDetail(
                        textColor: AppInfoReference.defaultAppColor,
                        value:
                            'App Version : ${AppInfoReference.currentAppVersion}',
                      ),
                      const AboutDetail(
                        textColor: AppInfoReference.defaultAppColor,
                        value: 'App Id : ${AppInfoReference.androidId}',
                      ),
                    ],
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
