import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    PrefUtils().setThemeData(_newTheme);
    Get.forceAppUpdate();
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: appTheme.gray900.withValues(alpha: 0.1),
          side: BorderSide(
            color: appTheme.gray900.withValues(alpha: 0.3),
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.h),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimaryContainer;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
          width: 1,
        ),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray100,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodyLarge: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 16.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 14.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 12.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      color: colorScheme.primary,
      fontSize: 24.fSize,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: appTheme.blueGray400,
      fontSize: 12.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: appTheme.gray90001,
      fontSize: 10.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: colorScheme.onPrimary,
      fontSize: 9.fSize,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 20.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 16.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: appTheme.blueGray900,
      fontSize: 14.fSize,
      fontFamily: 'DM Sans',
      fontWeight: FontWeight.w500,
    ),
  );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFF004BFD),
    primaryContainer: Color(0XFFF3F1FE),
    errorContainer: Color(0XFFED2061),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0XFF2D2D2D),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Amber
  Color get amber400 => Color(0XFFF9D11F);
  Color get amber700 => Color(0XFFFFA402);
  Color get amberA400 => Color(0XFFF9C900);
  // Black
  Color get black900 => Color(0XFF000000);
  // Blue
  Color get blue600 => Color(0XFF1877F1);
  Color get blueA400 => Color(0XFF1573FE);
  // BlueGray
  Color get blueGray100 => Color(0XFFD9D9D9);
  Color get blueGray400 => Color(0XFF7A869A);
  Color get blueGray50 => Color(0XFFEBECF0);
  Color get blueGray700 => Color(0XFF42526D);
  Color get blueGray900 => Color(0XFF162B4D);
  Color get blueGray90066 => Color(0X66081E42);
  // DeepOrange
  Color get deepOrange300 => Color(0XFFF49853);
  Color get deepOrange30001 => Color(0XFFF79E60);
  Color get deepOrange400 => Color(0XFFD77D41);
  Color get deepOrange50 => Color(0XFFFFEBE5);
  Color get deepOrangeA700 => Color(0XFFDE350B);
  // Gray
  Color get gray100 => Color(0XFFF4F5F7);
  Color get gray10001 => Color(0XFFF4F4F6);
  Color get gray200 => Color(0XFFEEEEEF);
  Color get gray20001 => Color(0XFFE8E8E8);
  Color get gray300 => Color(0XFFE1E1E1);
  Color get gray30001 => Color(0XFFE4E4E4);
  Color get gray30002 => Color(0XFFE3E4E8);
  Color get gray400 => Color(0XFFC1C7D0);
  Color get gray40001 => Color(0XFFB4B4B4);
  Color get gray40002 => Color(0XFFC1C6D0);
  Color get gray50 => Color(0XFFF3F8FF);
  Color get gray500 => Color(0XFF9E9E9E);
  Color get gray5001 => Color(0XFFFFFEF5);
  Color get gray5002 => Color(0XFFFCFCFC);
  Color get gray5003 => Color(0XFFF3FCFC);
  Color get gray700 => Color(0XFF666662);
  Color get gray800 => Color(0XFF3C3C3C);
  Color get gray900 => Color(0XFF191919);
  Color get gray90001 => Color(0XFF212429);
  Color get gray90002 => Color(0XFF1E1E1E);
  Color get gray90003 => Color(0XFF1D1D1B);
  Color get gray90021 => Color(0X211E1A11);
  // Green
  Color get green400 => Color(0XFF51E854);
  Color get green500 => Color(0XFF32D74B);
  Color get green50001 => Color(0XFF32D736);
  Color get green600 => Color(0XFF2AB52D);
  Color get green900 => Color(0XFF009903);
  Color get greenA200 => Color(0XFF7DFF7F);
  // Indigo
  Color get indigo900 => Color(0XFF00186A);
  // LightGreen
  Color get lightGreen600 => Color(0XFF68C044);
  Color get lightGreen800 => Color(0XFF599306);
  // Lime
  Color get lime800 => Color(0XFF77A505);
  // Orange
  Color get orange200 => Color(0XFFFEC986);
  Color get orange20001 => Color(0XFFFCC683);
  Color get orange20002 => Color(0XFFF7BE7F);
  Color get orange300 => Color(0XFFFEB860);
  Color get orange30001 => Color(0XFFFFA963);
  Color get orange400 => Color(0XFFFF991F);
  // Pink
  Color get pink400 => Color(0XFFC8546F);
  Color get pink700 => Color(0XFFC71E54);
  Color get pink800 => Color(0XFF9B4573);
  // Red
  Color get red500 => Color(0XFFF04336);
  Color get red700 => Color(0XFFD73232);
  Color get red900 => Color(0XFFA02E14);
  Color get redA400 => Color(0XFFF40B1C);
  // Teal
  Color get teal400 => Color(0XFF36B37E);
  Color get teal700 => Color(0XFF00875A);
  // Yellow
  Color get yellow100 => Color(0XFFFFF5CC);
  Color get yellow200 => Color(0XFFFDEDA5);
  Color get yellow400 => Color(0XFFFBDF63);
  Color get yellow50 => Color(0XFFFFF9E6);
  Color get yellow5001 => Color(0XFFFFF9E5);
  Color get yellow8007f => Color(0X7FEF9F27);
}
