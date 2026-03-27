// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'controller/intro_splash_controller.dart'; // ignore_for_file: must_be_immutable

class IntroSplashScreen extends GetWidget<IntroSplashController> {
  const IntroSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(child: SizedBox(height: 804.h, width: 392.h)),
    );
  }
}
