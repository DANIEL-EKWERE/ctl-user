import 'package:ctluser/data/model/selectionPopupModel/selection_popup_model.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../custom_drop_down.dart';

class AppbarTitleDropdown extends StatelessWidget {
  AppbarTitleDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    required this.onTap,
    this.margin,
  }) : super(key: key);

  final String? hintText;

  final List<SelectionPopupModel> items;

  final Function(SelectionPopupModel) onTap;

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: double.maxFinite,
        child: CustomDropDown(
          hintText: "msg_1014_prospect_vall".tr,
          items: items,
          contentPadding: EdgeInsets.all(12.h),
        ),
      ),
    );
  }
}
