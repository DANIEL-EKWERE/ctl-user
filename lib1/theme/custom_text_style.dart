import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get nexaTextTrial {
    return copyWith(fontFamily: 'Nexa Text-Trial');
  }

  TextStyle get dMSans {
    return copyWith(fontFamily: 'DM Sans');
  }

  TextStyle get nunitoSans {
    return copyWith(fontFamily: 'Nunito Sans');
  }

  TextStyle get poppins {
    return copyWith(fontFamily: 'Poppins');
  }

  TextStyle get mont {
    return copyWith(fontFamily: 'Mont');
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyMediumBluegray400 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.blueGray400);
  static TextStyle get bodyMediumBluegray400_1 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.blueGray400.withValues(alpha: 0.5));
  static TextStyle get bodyMediumBluegray400_2 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.blueGray400);
  static TextStyle get bodyMediumBluegray400_3 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.blueGray400.withValues(alpha: 0.5));
  static TextStyle get bodyMediumBluegray900 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.blueGray900.withValues(alpha: 0.5));
  static TextStyle get bodyMediumBluegray900_1 => theme.textTheme.bodyMedium!
      .copyWith(color: appTheme.blueGray900.withValues(alpha: 0.5));
  static TextStyle get bodyMediumMontGray900 => theme.textTheme.bodyMedium!.mont
      .copyWith(color: appTheme.gray900, fontSize: 15.fSize);
  static TextStyle get bodyMediumMontOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 15.fSize,
      );
  static TextStyle get bodyMediumNexaTextTrialGray900 =>
      theme.textTheme.bodyMedium!.nexaTextTrial.copyWith(
        color: appTheme.gray900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumNexaTextTrialOnPrimaryContainer =>
      theme.textTheme.bodyMedium!.nexaTextTrial.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumOnPrimary =>
      theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get bodyMediumPoppinsGray800 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: appTheme.gray800,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w300,
      );
  static TextStyle get bodyMediumPoppinsGray900 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
        color: appTheme.gray900,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w300,
      );
  static get bodyMedium_1 => theme.textTheme.bodyMedium!;
  static TextStyle get bodySmall11 =>
      theme.textTheme.bodySmall!.copyWith(fontSize: 11.fSize);
  static TextStyle get bodySmallMontOnPrimaryContainer =>
      theme.textTheme.bodySmall!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 11.fSize,
      );
  static TextStyle get bodySmallNunitoSansBlack900 =>
      theme.textTheme.bodySmall!.nunitoSans.copyWith(
        color: appTheme.black900.withValues(alpha: 0.6),
        fontSize: 11.fSize,
      );
  static TextStyle get bodySmallNunitoSansOnPrimaryContainer =>
      theme.textTheme.bodySmall!.nunitoSans.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 11.fSize,
      );
  // Headline text style
  static TextStyle get headlineSmallDMSansBluegray900 => theme
      .textTheme
      .headlineSmall!
      .dMSans
      .copyWith(color: appTheme.blueGray900, fontWeight: FontWeight.w700);
  static TextStyle get headlineSmallMontOnPrimaryContainer =>
      theme.textTheme.headlineSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w700,
      );
  // Label text style
  static TextStyle get labelLargeBluegray900 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.blueGray900);
  static TextStyle get labelLargeBluegray90013 => theme.textTheme.labelLarge!
      .copyWith(color: appTheme.blueGray900, fontSize: 13.fSize);
  static TextStyle get labelLargeBluegray90013_2 => theme.textTheme.labelLarge!
      .copyWith(color: appTheme.blueGray900, fontSize: 13.fSize);
  static TextStyle get labelLargeBluegray900_1 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.blueGray900);
  static TextStyle get labelLargeBluegray900_2 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.blueGray900);
  static TextStyle get labelLargeDeeporangeA700 => theme.textTheme.labelLarge!
      .copyWith(color: appTheme.deepOrangeA700, fontSize: 13.fSize);
  static TextStyle get labelLargeGray400 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.gray400);
  static TextStyle get labelLargeMontGray900 => theme.textTheme.labelLarge!.mont
      .copyWith(color: appTheme.gray900, fontSize: 13.fSize);
  static TextStyle get labelLargeMontGray90013 => theme
      .textTheme
      .labelLarge!
      .mont
      .copyWith(color: appTheme.gray900, fontSize: 13.fSize);
  static TextStyle get labelLargeMontOnPrimaryContainer =>
      theme.textTheme.labelLarge!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeMontOnPrimaryContainer13 =>
      theme.textTheme.labelLarge!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeMontOnPrimaryContainerSemiBold =>
      theme.textTheme.labelLarge!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelLargeMontPrimary =>
      theme.textTheme.labelLarge!.mont.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelLargeMontPrimary13 => theme
      .textTheme
      .labelLarge!
      .mont
      .copyWith(color: theme.colorScheme.primary, fontSize: 13.fSize);
  static TextStyle get labelLargeOnPrimary =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get labelLargeOnPrimary_1 =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get labelLargePrimary =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get labelLargePrimary13 => theme.textTheme.labelLarge!
      .copyWith(color: theme.colorScheme.primary, fontSize: 13.fSize);
  static TextStyle get labelLargePrimary13_1 => theme.textTheme.labelLarge!
      .copyWith(color: theme.colorScheme.primary, fontSize: 13.fSize);
  static TextStyle get labelLargePrimary_1 => theme.textTheme.labelLarge!
      .copyWith(color: theme.colorScheme.primary.withValues(alpha: 0.8));
  static TextStyle get labelLargePrimary_2 =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get labelLargePrimary_3 =>
      theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get labelLargeTeal700 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.teal700);
  static TextStyle get labelLargeTeal700_2 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.teal700);
  static TextStyle get labelLargeYellow8007f =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.yellow8007f);
  static TextStyle get labelMediumDMSansBluegray900 => theme
      .textTheme
      .labelMedium!
      .dMSans
      .copyWith(color: appTheme.blueGray900, fontWeight: FontWeight.w500);
  static TextStyle get labelMediumDMSansPrimary => theme
      .textTheme
      .labelMedium!
      .dMSans
      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500);
  static TextStyle get labelMediumMontBlack900 =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: appTheme.black900.withValues(alpha: 0.6),
        fontSize: 11.fSize,
      );
  static TextStyle get labelMediumMontBlack900Medium =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: appTheme.black900.withValues(alpha: 0.6),
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumMontBlueA400 =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: appTheme.blueA400,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumMontBlueA40011 => theme
      .textTheme
      .labelMedium!
      .mont
      .copyWith(color: appTheme.blueA400, fontSize: 11.fSize);
  static TextStyle get labelMediumMontBlueA400Medium =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: appTheme.blueA400,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumMontGray900 => theme
      .textTheme
      .labelMedium!
      .mont
      .copyWith(color: appTheme.gray900.withValues(alpha: 0.7));
  static TextStyle get labelMediumMontOnPrimaryContainer =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumMontOnPrimaryContainerMedium =>
      theme.textTheme.labelMedium!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  // Title text style
  static TextStyle get titleLarge21 =>
      theme.textTheme.titleLarge!.copyWith(fontSize: 21.fSize);
  static TextStyle get titleLargeMontGray900 =>
      theme.textTheme.titleLarge!.mont.copyWith(
        color: appTheme.gray900,
        fontSize: 22.fSize,
        fontWeight: FontWeight.w800,
      );
  static TextStyle get titleLargeMontPrimary => theme.textTheme.titleLarge!.mont
      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w800);
  static TextStyle get titleLargeMontPrimarySemiBold =>
      theme.textTheme.titleLarge!.mont.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 22.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargePoppinsPrimary =>
      theme.textTheme.titleLarge!.poppins.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 22.fSize,
        fontWeight: FontWeight.w400,
      );
  static TextStyle get titleLargePrimary => theme.textTheme.titleLarge!
      .copyWith(color: theme.colorScheme.primary, fontSize: 21.fSize);
  static TextStyle get titleMediumBold =>
      theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get titleMediumBold_1 =>
      theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get titleMediumBold_2 =>
      theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get titleMediumOnPrimary_1 =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get titleMediumOnPrimary_2 =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get titleMediumPrimary =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleMediumPrimary_1 =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary);
  static get titleMedium_1 => theme.textTheme.titleMedium!;
  static TextStyle get titleSmallBold =>
      theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get titleSmallGray400 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray400);
  static TextStyle get titleSmallMontGray5001 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray5001, fontWeight: FontWeight.w800);
  static TextStyle get titleSmallMontGray900 => theme.textTheme.titleSmall!.mont
      .copyWith(color: appTheme.gray900, fontWeight: FontWeight.w800);
  static TextStyle get titleSmallMontGray90015 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray900, fontSize: 15.fSize);
  static TextStyle get titleSmallMontGray90015_1 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray900, fontSize: 15.fSize);
  static TextStyle get titleSmallMontGray90015_2 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray900, fontSize: 15.fSize);
  static TextStyle get titleSmallMontGray900Bold =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: appTheme.gray900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallMontGray900Bold_1 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray900, fontWeight: FontWeight.w700);
  static TextStyle get titleSmallMontGray900SemiBold =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: appTheme.gray900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallMontGray900_1 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: appTheme.gray900.withValues(alpha: 0.4));
  static TextStyle get titleSmallMontGray900_2 =>
      theme.textTheme.titleSmall!.mont.copyWith(color: appTheme.gray900);
  static TextStyle get titleSmallMontOnPrimary =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallMontOnPrimaryBold =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallMontOnPrimaryContainer =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.4),
        fontWeight: FontWeight.w800,
      );
  static TextStyle get titleSmallMontOnPrimaryContainer15 =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 15.fSize,
      );
  static TextStyle get titleSmallMontOnPrimaryContainer_1 => theme
      .textTheme
      .titleSmall!
      .mont
      .copyWith(color: theme.colorScheme.onPrimaryContainer);
  static TextStyle get titleSmallMontOnPrimaryContainer_2 =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
      );
  static TextStyle get titleSmallMontOnPrimaryExtraBold =>
      theme.textTheme.titleSmall!.mont.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w800,
      );
  static TextStyle get titleSmallNexaTextTrialGray90002 =>
      theme.textTheme.titleSmall!.nexaTextTrial.copyWith(
        color: appTheme.gray90002,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallOnPrimary =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get titleSmallOnPrimary_1 =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get titleSmallOnPrimary_2 =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.onPrimary);
  static TextStyle get titleSmallPrimary => theme.textTheme.titleSmall!
      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700);
  static TextStyle get titleSmallPrimaryBold =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primary.withValues(alpha: 0.8),
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleSmallPrimary_1 =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleSmallPrimary_2 =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleSmallSemiBold =>
      theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600);
  static get titleSmall_1 => theme.textTheme.titleSmall!;
}
