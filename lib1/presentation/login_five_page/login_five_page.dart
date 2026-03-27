// Redesigned: Search/Browse tab placeholder (routed internally)
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import 'controller/login_five_controller.dart';
import 'models/login_five_model.dart';
import '../search_vone_screen/search_vone_screen.dart';

// ignore_for_file: must_be_immutable
class LoginFivePage extends StatelessWidget {
  LoginFivePage({Key? key}) : super(key: key);
  LoginFiveController controller = Get.put(LoginFiveController(LoginFiveModel().obs));

  @override
  Widget build(BuildContext context) {
    // Browse tab just renders the search screen inline
    return const SearchVoneScreen();
  }
}
