import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillGray => BoxDecoration(color: appTheme.gray30001);
  static BoxDecoration get fillGray10001 =>
      BoxDecoration(color: appTheme.gray10001);
  static BoxDecoration get fillGray5003 =>
      BoxDecoration(color: appTheme.gray5003);
  static BoxDecoration get fillGray90001 =>
      BoxDecoration(color: appTheme.gray90001);
  static BoxDecoration get fillPrimary =>
      BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.1));
  static BoxDecoration get fillPrimaryContainer =>
      BoxDecoration(color: theme.colorScheme.primaryContainer);
  static BoxDecoration get fillYellow =>
      BoxDecoration(color: appTheme.yellow50);
  // Neutral decorations
  static BoxDecoration get neutral00 =>
      BoxDecoration(color: theme.colorScheme.onPrimary);
  static BoxDecoration get neutral900 =>
      BoxDecoration(color: appTheme.blueGray90066);
  // Outline decorations
  static BoxDecoration get outlineGray => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    boxShadow: [
      BoxShadow(
        color: appTheme.gray90021,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 7.38),
      ),
    ],
  );
  static BoxDecoration get outlineGray100 => BoxDecoration(
    color: theme.colorScheme.onPrimary,
    border: Border(bottom: BorderSide(color: appTheme.gray100, width: 1.h)),
  );
  static BoxDecoration get outlineGray1001 =>
      BoxDecoration(border: Border.all(color: appTheme.gray100, width: 1.h));
  static BoxDecoration get outlineGray90021 => BoxDecoration(
    color: theme.colorScheme.primary,
    boxShadow: [
      BoxShadow(
        color: appTheme.gray90021,
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 7.38),
      ),
    ],
  );
  // Red decorations
  static BoxDecoration get red50 =>
      BoxDecoration(color: appTheme.deepOrange50.withValues(alpha: 0.2));
  // Yellow decorations
  static BoxDecoration get yellow50 =>
      BoxDecoration(color: appTheme.yellow5001);
  // Fs decorations
  static BoxDecoration get fs42Cardlist =>
      BoxDecoration(color: appTheme.gray100);
  // Stack decorations
  static BoxDecoration get stack12 => BoxDecoration(
    image: DecorationImage(
      image: AssetImage(ImageConstant.imgSnazzyimage1),
      fit: BoxFit.fill,
    ),
  );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder20 => BorderRadius.circular(20.h);
  static BorderRadius get circleBorder40 => BorderRadius.circular(40.h);
  static BorderRadius get circleBorder50 => BorderRadius.circular(50.h);
  // Custom borders
  static BorderRadius get customBorderBL12 =>
      BorderRadius.vertical(bottom: Radius.circular(12.h));
  static BorderRadius get customBorderBL20 =>
      BorderRadius.vertical(bottom: Radius.circular(20.h));
  static BorderRadius get customBorderBL30 =>
      BorderRadius.vertical(bottom: Radius.circular(30.h));
  static BorderRadius get customBorderBL6 =>
      BorderRadius.vertical(bottom: Radius.circular(6.h));
  static BorderRadius get customBorderTL30 =>
      BorderRadius.vertical(top: Radius.circular(30.h));
  // Rounded borders
  static BorderRadius get roundedBorder14 => BorderRadius.circular(14.h);
  static BorderRadius get roundedBorder5 => BorderRadius.circular(5.h);
  static BorderRadius get roundedBorder8 => BorderRadius.circular(8.h);
}
