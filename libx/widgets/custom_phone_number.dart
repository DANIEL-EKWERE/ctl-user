import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import '../core/app_export.dart';

// ignore_for_file: must_be_immutable
class CustomPhoneNumber extends StatelessWidget {
  CustomPhoneNumber({
    Key? key,
    required this.country,
    required this.onTap,
    required this.controller,
  }) : super(key: key);

  Country country;

  Function(Country) onTap;

  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: appTheme.gray300, width: 1.h),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _openCountryPicker(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 16.h),
              decoration: BoxDecoration(
                color: appTheme.gray300,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(8.h),
                ),
                border: Border.all(color: appTheme.gray300, width: 1.h),
              ),
              child: Row(
                children: [
                  Text(
                    "+${country.phoneCode}",
                    style: CustomTextStyles.titleSmallMontOnPrimaryContainer_1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h, top: 6.h),
                    child: CountryPickerUtils.getDefaultFlagImage(country),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 270.h,
              margin: EdgeInsets.only(left: 22.h),
              child: TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                controller: controller,
                style: CustomTextStyles.titleSmallMontOnPrimaryContainer_2,
                decoration: InputDecoration(
                  hintText: "lbl_012_345_6789".tr,
                  hintStyle:
                      CustomTextStyles.titleSmallMontOnPrimaryContainer_2,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.all(16.h),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      Container(
        margin: EdgeInsets.only(left: 10.h),
        width: 60.h,
        child: Text(
          "+${country.phoneCode}",
          style: TextStyle(fontSize: 14.fSize),
        ),
      ),
      const SizedBox(width: 8.0),
      Flexible(child: Text(country.name, style: TextStyle(fontSize: 14.fSize))),
    ],
  );
  void _openCountryPicker(BuildContext context) => showDialog(
    context: context,
    builder:
        (context) => CountryPickerDialog(
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14.fSize),
          ),
          isSearchable: true,
          title: Text(
            'Select your phone code',
            style: TextStyle(fontSize: 14.fSize),
          ),
          onValuePicked: (Country country) => onTap(country),
          itemBuilder: _buildDialogItem,
        ),
  );
}
