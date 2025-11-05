import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlueGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.blueGray50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.h)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillDeepOrange => ElevatedButton.styleFrom(
    backgroundColor: appTheme.deepOrange50.withValues(alpha: 0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.h)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillGray => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray5002,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.h)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillGrayTL14 => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray100,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.h)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillGrayTL22 => ElevatedButton.styleFrom(
    backgroundColor: appTheme.gray100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22.h)),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get fillPrimaryTL22 => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22.h)),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
  // Outline button style
  static ButtonStyle get outlineGrayTL8 => OutlinedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    side: BorderSide(color: appTheme.gray300, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
    padding: EdgeInsets.zero,
  );
  static ButtonStyle get outlineOnPrimaryContainer => OutlinedButton.styleFrom(
    backgroundColor: appTheme.gray200,
    side: BorderSide(
      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.04),
      width: 1,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
    padding: EdgeInsets.zero,
  );
  // text button style
  static ButtonStyle get none => ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
    elevation: WidgetStateProperty.all<double>(0),
    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
    side: WidgetStateProperty.all<BorderSide>(
      BorderSide(color: Colors.transparent),
    ),
  );
}
