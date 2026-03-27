import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_search_view.dart';

class AppbarTitleSearchview extends StatelessWidget {
  AppbarTitleSearchview({Key? key, this.hintText, this.controller, this.margin})
    : super(key: key);

  final String? hintText;

  final TextEditingController? controller;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: double.maxFinite,
        child: CustomSearchView(
          controller: controller,
          hintText: "lbl_search_on_coody".tr,
          contentPadding: EdgeInsets.fromLTRB(12.h, 10.h, 10.h, 10.h),
        ),
      ),
    );
  }
}
