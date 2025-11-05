// TODO Implement this library.
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/chipviewlabel_item_model.dart';

// ignore_for_file: must_be_immutable
class ChipviewlabelItemWidget extends StatelessWidget {
  ChipviewlabelItemWidget(this.chipviewlabelItemModelObj, {Key? key})
    : super(key: key);

  ChipviewlabelItemModel chipviewlabelItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RawChip(
        padding: EdgeInsets.all(10.h),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          chipviewlabelItemModelObj.labelFour!.value,
          style: TextStyle(
            color:
                (chipviewlabelItemModelObj.isSelected?.value ?? false)
                    ? appTheme.blueGray900
                    : theme.colorScheme.onPrimary,
            fontSize: 14.fSize,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w400,
          ),
        ),
        selected: (chipviewlabelItemModelObj.isSelected?.value ?? false),
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.8),
        selectedColor: appTheme.gray100,
        side: BorderSide.none,
        shape:
            (chipviewlabelItemModelObj.isSelected?.value ?? false)
                ? RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.h),
                )
                : RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.h),
                ),
        onSelected: (value) {
          chipviewlabelItemModelObj.isSelected!.value = value;
        },
      ),
    );
  }
}
