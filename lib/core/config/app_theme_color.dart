import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_color.dart';

class AppThemeColor extends ThemeExtension<AppThemeColor> {
  // Existing properties
  final Color scaffoldBachgroundColor;
  final Color primaryColor;
  final Color whiteColor;
  final Color backgroundColor;
  final Color modalBgColor;
  final Color tapGroupBgColor;
  final Color tabActiveColor;
  final Color borderColor;
  final Color titleColor;
  final Color subTitleColor;
  final Color bodyColor;
  final Color placeHolderColor;
  final Color linkColor;
  final Color buttonColor;
  final Color buttonBgColor;
  final Color captionColor;
  final Color disableColor;
  final Color successColor;
  final Color warningColor;
  final Color errorColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  // Primary Color Properties
  final Color primaryColor950;
  final Color primaryColor900;
  final Color primaryColor800;
  final Color primaryColor700;
  final Color primaryColor600;
  final Color primaryColor500;
  final Color primaryColor400;
  final Color primaryColor300;
  final Color primaryColor200;
  final Color primaryColor100;
  final Color primaryColor75;
  final Color primaryColor50;
  final Color primaryColor25;

  // Black Color Properties
  final Color blackColor950;
  final Color blackColor900;
  final Color blackColor800;
  final Color blackColor700;
  final Color blackColor600;
  final Color blackColor500;
  final Color blackColor400;
  final Color blackColor300;
  final Color blackColor200;
  final Color blackColor100;
  final Color blackColor50;

  // Error Color Properties
  final Color errorColor900;
  final Color errorColor800;
  final Color errorColor700;
  final Color errorColor600;
  final Color errorColor500;
  final Color errorColor400;
  final Color errorColor300;
  final Color errorColor200;
  final Color errorColor100;
  final Color errorColor50;
  final Color errorColor25;

  // New Button Properties
  final Color primaryBtn;
  final Color secondaryBtn;
  final Color btnIcon2;
  final Color btnIcon;
  final Color btnText;
  final Color filledText;

  // New Text Color Properties
  final Color secondaryTitleColor;
  final Color secondarySubTitleColor;
  final Color primaryGradient;
  final Color secondaryGradient;
  final Color primaryButtonGradient;
  final Color secondaryButtonGradient;
  final Color strokePrimary;

  const AppThemeColor({
    // Existing required properties
    required this.scaffoldBachgroundColor,
    required this.primaryColor,
    required this.whiteColor,
    required this.backgroundColor,
    required this.modalBgColor,
    required this.tapGroupBgColor,
    required this.tabActiveColor,
    required this.borderColor,
    required this.titleColor,
    required this.subTitleColor,
    required this.bodyColor,
    required this.placeHolderColor,
    required this.linkColor,
    required this.buttonColor,
    required this.buttonBgColor,
    required this.captionColor,
    required this.disableColor,
    required this.successColor,
    required this.warningColor,
    required this.errorColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,

    // Primary Color required properties
    required this.primaryColor950,
    required this.primaryColor900,
    required this.primaryColor800,
    required this.primaryColor700,
    required this.primaryColor600,
    required this.primaryColor500,
    required this.primaryColor400,
    required this.primaryColor300,
    required this.primaryColor200,
    required this.primaryColor100,
    required this.primaryColor75,
    required this.primaryColor50,
    required this.primaryColor25,

    // Black Color required properties
    required this.blackColor950,
    required this.blackColor900,
    required this.blackColor800,
    required this.blackColor700,
    required this.blackColor600,
    required this.blackColor500,
    required this.blackColor400,
    required this.blackColor300,
    required this.blackColor200,
    required this.blackColor100,
    required this.blackColor50,

    // Error Color required properties
    required this.errorColor900,
    required this.errorColor800,
    required this.errorColor700,
    required this.errorColor600,
    required this.errorColor500,
    required this.errorColor400,
    required this.errorColor300,
    required this.errorColor200,
    required this.errorColor100,
    required this.errorColor50,
    required this.errorColor25,

    // New Button required properties
    required this.primaryBtn,
    required this.secondaryBtn,
    required this.btnIcon2,
    required this.btnIcon,
    required this.btnText,
    required this.filledText,

    // New Text Color required properties
    required this.secondaryTitleColor,
    required this.secondarySubTitleColor,
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.primaryButtonGradient,
    required this.secondaryButtonGradient,
    required this.strokePrimary,
  });

  @override
  AppThemeColor copyWith({
    // Existing properties
    Color? scaffoldBachgroundColor,
    Color? primaryColor,
    Color? whiteColor,
    Color? backgroundColor,
    Color? modalBgColor,
    Color? tapGroupBgColor,
    Color? tabActiveColor,
    Color? borderColor,
    Color? titleColor,
    Color? subTitleColor,
    Color? bodyColor,
    Color? placeHolderColor,
    Color? linkColor,
    Color? buttonColor,
    Color? buttonBgColor,
    Color? captionColor,
    Color? disableColor,
    Color? successColor,
    Color? warningColor,
    Color? errorColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,

    // Primary Color properties
    Color? primaryColor950,
    Color? primaryColor900,
    Color? primaryColor800,
    Color? primaryColor700,
    Color? primaryColor600,
    Color? primaryColor500,
    Color? primaryColor400,
    Color? primaryColor300,
    Color? primaryColor200,
    Color? primaryColor100,
    Color? primaryColor75,
    Color? primaryColor50,
    Color? primaryColor25,

    // Black Color properties
    Color? blackColor950,
    Color? blackColor900,
    Color? blackColor800,
    Color? blackColor700,
    Color? blackColor600,
    Color? blackColor500,
    Color? blackColor400,
    Color? blackColor300,
    Color? blackColor200,
    Color? blackColor100,
    Color? blackColor50,

    // Error Color properties
    Color? errorColor900,
    Color? errorColor800,
    Color? errorColor700,
    Color? errorColor600,
    Color? errorColor500,
    Color? errorColor400,
    Color? errorColor300,
    Color? errorColor200,
    Color? errorColor100,
    Color? errorColor50,
    Color? errorColor25,

    // New Button properties
    Color? primaryBtn,
    Color? secondaryBtn,
    Color? btnIcon2,
    Color? btnIcon,
    Color? btnText,
    Color? filledText,

    // New Text Color properties
    Color? secondaryTitleColor,
    Color? secondarySubTitleColor,
    Color? primaryGradient,
    Color? secondaryGradient,
    Color? strokePrimary,
  }) {
    return AppThemeColor(
      // Existing properties
      scaffoldBachgroundColor:
          scaffoldBachgroundColor ?? this.scaffoldBachgroundColor,
      primaryColor: primaryColor ?? this.primaryColor,
      whiteColor: whiteColor ?? this.whiteColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      modalBgColor: modalBgColor ?? this.modalBgColor,
      tapGroupBgColor: tapGroupBgColor ?? this.tapGroupBgColor,
      tabActiveColor: tabActiveColor ?? this.tabActiveColor,
      borderColor: borderColor ?? this.borderColor,
      titleColor: titleColor ?? this.titleColor,
      subTitleColor: subTitleColor ?? this.subTitleColor,
      bodyColor: bodyColor ?? this.bodyColor,
      placeHolderColor: placeHolderColor ?? this.placeHolderColor,
      linkColor: linkColor ?? this.linkColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonBgColor: buttonBgColor ?? this.buttonBgColor,
      captionColor: captionColor ?? this.captionColor,
      disableColor: disableColor ?? this.disableColor,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      errorColor: errorColor ?? this.errorColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,

      // Primary Color properties
      primaryColor950: primaryColor950 ?? this.primaryColor950,
      primaryColor900: primaryColor900 ?? this.primaryColor900,
      primaryColor800: primaryColor800 ?? this.primaryColor800,
      primaryColor700: primaryColor700 ?? this.primaryColor700,
      primaryColor600: primaryColor600 ?? this.primaryColor600,
      primaryColor500: primaryColor500 ?? this.primaryColor500,
      primaryColor400: primaryColor400 ?? this.primaryColor400,
      primaryColor300: primaryColor300 ?? this.primaryColor300,
      primaryColor200: primaryColor200 ?? this.primaryColor200,
      primaryColor100: primaryColor100 ?? this.primaryColor100,
      primaryColor75: primaryColor75 ?? this.primaryColor75,
      primaryColor50: primaryColor50 ?? this.primaryColor50,
      primaryColor25: primaryColor25 ?? this.primaryColor25,

      // Black Color properties
      blackColor950: blackColor950 ?? this.blackColor950,
      blackColor900: blackColor900 ?? this.blackColor900,
      blackColor800: blackColor800 ?? this.blackColor800,
      blackColor700: blackColor700 ?? this.blackColor700,
      blackColor600: blackColor600 ?? this.blackColor600,
      blackColor500: blackColor500 ?? this.blackColor500,
      blackColor400: blackColor400 ?? this.blackColor400,
      blackColor300: blackColor300 ?? this.blackColor300,
      blackColor200: blackColor200 ?? this.blackColor200,
      blackColor100: blackColor100 ?? this.blackColor100,
      blackColor50: blackColor50 ?? this.blackColor50,

      // Error Color properties
      errorColor900: errorColor900 ?? this.errorColor900,
      errorColor800: errorColor800 ?? this.errorColor800,
      errorColor700: errorColor700 ?? this.errorColor700,
      errorColor600: errorColor600 ?? this.errorColor600,
      errorColor500: errorColor500 ?? this.errorColor500,
      errorColor400: errorColor400 ?? this.errorColor400,
      errorColor300: errorColor300 ?? this.errorColor300,
      errorColor200: errorColor200 ?? this.errorColor200,
      errorColor100: errorColor100 ?? this.errorColor100,
      errorColor50: errorColor50 ?? this.errorColor50,
      errorColor25: errorColor25 ?? this.errorColor25,

      // New Button properties
      primaryBtn: primaryBtn ?? this.primaryBtn,
      secondaryBtn: secondaryBtn ?? this.secondaryBtn,
      btnIcon2: btnIcon2 ?? this.btnIcon2,
      btnIcon: btnIcon ?? this.btnIcon,
      btnText: btnText ?? this.btnText,
      filledText: filledText ?? this.filledText,

      // New Text Color properties
      secondaryTitleColor: secondaryTitleColor ?? this.secondaryTitleColor,
      secondarySubTitleColor:
          secondarySubTitleColor ?? this.secondarySubTitleColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      primaryButtonGradient: primaryButtonGradient,
      secondaryButtonGradient: secondaryButtonGradient,
      strokePrimary: strokePrimary ?? this.strokePrimary,
    );
  }

  @override
  ThemeExtension<AppThemeColor> lerp(
    ThemeExtension<AppThemeColor>? other,
    double t,
  ) {
    if (other is! AppThemeColor) {
      return this;
    }
    return AppThemeColor(
      // Existing properties
      scaffoldBachgroundColor:
          Color.lerp(
            scaffoldBachgroundColor,
            other.scaffoldBachgroundColor,
            t,
          )!,
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      whiteColor: Color.lerp(whiteColor, other.whiteColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      modalBgColor: Color.lerp(modalBgColor, other.modalBgColor, t)!,
      tapGroupBgColor: Color.lerp(tapGroupBgColor, other.tapGroupBgColor, t)!,
      tabActiveColor: Color.lerp(tabActiveColor, other.tabActiveColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      subTitleColor: Color.lerp(subTitleColor, other.subTitleColor, t)!,
      bodyColor: Color.lerp(bodyColor, other.bodyColor, t)!,
      placeHolderColor:
          Color.lerp(placeHolderColor, other.placeHolderColor, t)!,
      linkColor: Color.lerp(linkColor, other.linkColor, t)!,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t)!,
      buttonBgColor: Color.lerp(buttonBgColor, other.buttonBgColor, t)!,
      captionColor: Color.lerp(captionColor, other.captionColor, t)!,
      disableColor: Color.lerp(disableColor, other.disableColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      warningColor: Color.lerp(warningColor, other.warningColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,

      // Primary Color properties
      primaryColor950: Color.lerp(primaryColor950, other.primaryColor950, t)!,
      primaryColor900: Color.lerp(primaryColor900, other.primaryColor900, t)!,
      primaryColor800: Color.lerp(primaryColor800, other.primaryColor800, t)!,
      primaryColor700: Color.lerp(primaryColor700, other.primaryColor700, t)!,
      primaryColor600: Color.lerp(primaryColor600, other.primaryColor600, t)!,
      primaryColor500: Color.lerp(primaryColor500, other.primaryColor500, t)!,
      primaryColor400: Color.lerp(primaryColor400, other.primaryColor400, t)!,
      primaryColor300: Color.lerp(primaryColor300, other.primaryColor300, t)!,
      primaryColor200: Color.lerp(primaryColor200, other.primaryColor200, t)!,
      primaryColor100: Color.lerp(primaryColor100, other.primaryColor100, t)!,
      primaryColor75: Color.lerp(primaryColor75, other.primaryColor75, t)!,
      primaryColor50: Color.lerp(primaryColor50, other.primaryColor50, t)!,
      primaryColor25: Color.lerp(primaryColor25, other.primaryColor25, t)!,

      // Black Color properties
      blackColor950: Color.lerp(blackColor950, other.blackColor950, t)!,
      blackColor900: Color.lerp(blackColor900, other.blackColor900, t)!,
      blackColor800: Color.lerp(blackColor800, other.blackColor800, t)!,
      blackColor700: Color.lerp(blackColor700, other.blackColor700, t)!,
      blackColor600: Color.lerp(blackColor600, other.blackColor600, t)!,
      blackColor500: Color.lerp(blackColor500, other.blackColor500, t)!,
      blackColor400: Color.lerp(blackColor400, other.blackColor400, t)!,
      blackColor300: Color.lerp(blackColor300, other.blackColor300, t)!,
      blackColor200: Color.lerp(blackColor200, other.blackColor200, t)!,
      blackColor100: Color.lerp(blackColor100, other.blackColor100, t)!,
      blackColor50: Color.lerp(blackColor50, other.blackColor50, t)!,

      // Error Color properties
      errorColor900: Color.lerp(errorColor900, other.errorColor900, t)!,
      errorColor800: Color.lerp(errorColor800, other.errorColor800, t)!,
      errorColor700: Color.lerp(errorColor700, other.errorColor700, t)!,
      errorColor600: Color.lerp(errorColor600, other.errorColor600, t)!,
      errorColor500: Color.lerp(errorColor500, other.errorColor500, t)!,
      errorColor400: Color.lerp(errorColor400, other.errorColor400, t)!,
      errorColor300: Color.lerp(errorColor300, other.errorColor300, t)!,
      errorColor200: Color.lerp(errorColor200, other.errorColor200, t)!,
      errorColor100: Color.lerp(errorColor100, other.errorColor100, t)!,
      errorColor50: Color.lerp(errorColor50, other.errorColor50, t)!,
      errorColor25: Color.lerp(errorColor25, other.errorColor25, t)!,

      // New Button properties
      primaryBtn: Color.lerp(primaryBtn, other.primaryBtn, t)!,
      secondaryBtn: Color.lerp(secondaryBtn, other.secondaryBtn, t)!,
      btnIcon2: Color.lerp(btnIcon2, other.btnIcon2, t)!,
      btnIcon: Color.lerp(btnIcon, other.btnIcon, t)!,
      btnText: Color.lerp(btnText, other.btnText, t)!,
      filledText: Color.lerp(filledText, other.filledText, t)!,

      // New Text Color properties
      secondaryTitleColor:
          Color.lerp(secondaryTitleColor, other.secondaryTitleColor, t)!,
      secondarySubTitleColor:
          Color.lerp(secondarySubTitleColor, other.secondarySubTitleColor, t)!,
      primaryTextColor:
          Color.lerp(primaryTextColor, other.primaryTextColor, t)!,
      secondaryTextColor:
          Color.lerp(secondaryTextColor, other.secondaryTextColor, t)!,
      primaryGradient: Color.lerp(primaryGradient, other.primaryGradient, t)!,
      secondaryGradient:
          Color.lerp(secondaryGradient, other.secondaryGradient, t)!,
      primaryButtonGradient:
          Color.lerp(primaryButtonGradient, other.primaryButtonGradient, t)!,
      secondaryButtonGradient:
          Color.lerp(
            secondaryButtonGradient,
            other.secondaryButtonGradient,
            t,
          )!,
      strokePrimary: Color.lerp(strokePrimary, other.strokePrimary, t)!,
    );
  }

  // Light theme instance
  static var light = AppThemeColor(
    // Existing properties
    scaffoldBachgroundColor: AppColor.background,
    primaryColor: AppColor.primary,
    whiteColor: AppColor.white,
    backgroundColor: AppColor.background,
    modalBgColor: AppColor.white,
    tapGroupBgColor: AppColor.white,
    tabActiveColor: AppColor.primary,
    borderColor: AppColor.border,
    titleColor: AppColor.textPrimary,
    subTitleColor: AppColor.textSecondary,
    bodyColor: AppColor.textPrimary,
    placeHolderColor: AppColor.textSecondary,
    linkColor: AppColor.primary,
    buttonColor: AppColor.white,
    buttonBgColor: AppColor.primary,
    captionColor: AppColor.textSecondary,
    disableColor: AppColor.textSecondary,
    successColor: AppColor.success,
    warningColor: AppColor.warning,
    errorColor: AppColor.danger,
    primaryTextColor: AppColor.textPrimary,
    secondaryTextColor: AppColor.textSecondary,
    primaryGradient: AppColor.passengerPrimaryGradient,
    secondaryGradient: AppColor.passengerSecondaryGradient,

    // Primary color shades
    primaryColor950: AppColor.primary,
    primaryColor900: AppColor.primary,
    primaryColor800: AppColor.primary,
    primaryColor700: AppColor.primary,
    primaryColor600: AppColor.primary,
    primaryColor500: AppColor.primary,
    primaryColor400: AppColor.primary,
    primaryColor300: AppColor.primary,
    primaryColor200: AppColor.primary,
    primaryColor100: AppColor.primary,
    primaryColor75: AppColor.primary,
    primaryColor50: AppColor.primary,
    primaryColor25: AppColor.primary,

    // Black color shades
    blackColor950: AppColor.textPrimary,
    blackColor900: AppColor.textPrimary,
    blackColor800: AppColor.textPrimary,
    blackColor700: AppColor.textPrimary,
    blackColor600: AppColor.textPrimary,
    blackColor500: AppColor.textPrimary,
    blackColor400: AppColor.textPrimary,
    blackColor300: AppColor.textPrimary,
    blackColor200: AppColor.textPrimary,
    blackColor100: AppColor.textPrimary,
    blackColor50: AppColor.textPrimary,

    // Error color shades
    errorColor900: AppColor.errorColor900,
    errorColor800: AppColor.errorColor800,
    errorColor700: AppColor.errorColor700,
    errorColor600: AppColor.errorColor600,
    errorColor500: AppColor.errorColor500,
    errorColor400: AppColor.errorColor400,
    errorColor300: AppColor.errorColor300,
    errorColor200: AppColor.errorColor200,
    errorColor100: AppColor.errorColor100,
    errorColor50: AppColor.errorColor50,
    errorColor25: AppColor.errorColor25,

    // Button properties
    primaryBtn: AppColor.primary,
    secondaryBtn: AppColor.secondary,
    btnIcon2: AppColor.secondary,
    btnIcon: AppColor.primary,
    btnText: AppColor.textPrimary,
    filledText: AppColor.white,

    // Text color properties
    secondaryTitleColor: AppColor.textSecondary,
    secondarySubTitleColor: AppColor.textSecondary,
    primaryButtonGradient: AppColor.driverPrimaryButtonGradient,
    secondaryButtonGradient: AppColor.driverSecondaryButtonGradient,
    strokePrimary: AppColor.driverStrokePrimary,
  );

  // Passenger theme instance
  static var passenger = AppThemeColor(
    scaffoldBachgroundColor: AppColor.passengerSurfacePrimary,
    primaryColor: AppColor.passengerButtonPrimaryStart,
    whiteColor: AppColor.white,
    backgroundColor: AppColor.passengerSurfacePrimary,
    modalBgColor: AppColor.white,
    tapGroupBgColor: AppColor.white,
    tabActiveColor: AppColor.passengerButtonPrimaryStart,
    borderColor: AppColor.passengerBorder,
    titleColor: AppColor.passengerTextSecondary,
    subTitleColor: AppColor.passengerTextSecondary,
    bodyColor: AppColor.passengerTextSecondary,
    placeHolderColor: AppColor.passengerTextSecondary,
    linkColor: AppColor.passengerButtonPrimaryStart,
    buttonColor: AppColor.passengerTextPrimary,
    buttonBgColor: AppColor.passengerButtonPrimaryStart,
    captionColor: AppColor.passengerTextSecondary,
    disableColor: AppColor.passengerInactive,
    successColor: AppColor.passengerSuccess,
    warningColor: AppColor.warning,
    errorColor: AppColor.passengerCancel,
    primaryTextColor: AppColor.passengerTextPrimary,
    secondaryTextColor: AppColor.passengerTextSecondary,
    primaryGradient: AppColor.passengerPrimaryGradient,
    secondaryGradient: AppColor.passengerSecondaryGradient,

    // Primary color shades
    primaryColor950: AppColor.passengerButtonPrimaryEnd,
    primaryColor900: AppColor.passengerButtonPrimaryEnd,
    primaryColor800: AppColor.passengerButtonPrimaryEnd,
    primaryColor700: AppColor.passengerButtonPrimaryStart,
    primaryColor600: AppColor.passengerButtonPrimaryStart,
    primaryColor500: AppColor.passengerButtonPrimaryStart,
    primaryColor400: AppColor.passengerButtonPrimaryStart,
    primaryColor300: AppColor.passengerBorder,
    primaryColor200: AppColor.passengerBorder,
    primaryColor100: AppColor.passengerBorder,
    primaryColor75: AppColor.passengerInactive,
    primaryColor50: AppColor.passengerInactive,
    primaryColor25: AppColor.passengerInactive,

    // Black color shades
    blackColor950: AppColor.passengerTextSecondary,
    blackColor900: AppColor.passengerTextSecondary,
    blackColor800: AppColor.passengerTextSecondary,
    blackColor700: AppColor.passengerTextSecondary,
    blackColor600: AppColor.passengerTextSecondary,
    blackColor500: AppColor.passengerTextSecondary,
    blackColor400: AppColor.passengerTextSecondary,
    blackColor300: AppColor.passengerTextSecondary,
    blackColor200: AppColor.passengerTextSecondary,
    blackColor100: AppColor.passengerTextSecondary,
    blackColor50: AppColor.passengerTextSecondary,

    // Error color shades
    errorColor900: AppColor.errorColor900,
    errorColor800: AppColor.errorColor800,
    errorColor700: AppColor.errorColor700,
    errorColor600: AppColor.errorColor600,
    errorColor500: AppColor.errorColor500,
    errorColor400: AppColor.errorColor400,
    errorColor300: AppColor.errorColor300,
    errorColor200: AppColor.errorColor200,
    errorColor100: AppColor.errorColor100,
    errorColor50: AppColor.errorColor50,
    errorColor25: AppColor.errorColor25,

    // Button properties
    primaryBtn: AppColor.passengerButtonPrimaryStart,
    secondaryBtn: AppColor.passengerButtonPrimaryEnd,
    btnIcon2: AppColor.passengerIcon,
    btnIcon: AppColor.passengerIcon,
    btnText: AppColor.passengerTextPrimary,
    filledText: AppColor.passengerTextPrimary,

    // Text color properties
    secondaryTitleColor: AppColor.passengerTextSecondary,
    secondarySubTitleColor: AppColor.passengerTextSecondary,
    primaryButtonGradient: AppColor.passengerPrimaryButtonGradient,
    secondaryButtonGradient: AppColor.passengerSecondaryButtonGradient,
    strokePrimary: AppColor.passengerStrokePrimary,
  );

  // Driver theme instance
  static var driver = AppThemeColor(
    scaffoldBachgroundColor: AppColor.driverSurfacePrimary,
    primaryColor: AppColor.driverButtonPrimaryStart,
    whiteColor: AppColor.white,
    backgroundColor: AppColor.driverSurfacePrimary,
    modalBgColor: AppColor.white,
    tapGroupBgColor: AppColor.white,
    tabActiveColor: AppColor.driverButtonPrimaryStart,
    borderColor: AppColor.driverBorder,
    titleColor: AppColor.driverTextSecondary,
    subTitleColor: AppColor.driverTextSecondary,
    bodyColor: AppColor.driverTextSecondary,
    placeHolderColor: AppColor.driverTextSecondary,
    linkColor: AppColor.driverButtonPrimaryStart,
    buttonColor: AppColor.driverTextPrimary,
    buttonBgColor: AppColor.driverButtonPrimaryStart,
    captionColor: AppColor.driverTextSecondary,
    disableColor: AppColor.driverInactive,
    successColor: AppColor.driverSuccess,
    warningColor: AppColor.warning,
    errorColor: AppColor.driverCancel,
    primaryTextColor: AppColor.driverTextPrimary,
    secondaryTextColor: AppColor.driverTextSecondary,
    primaryGradient: AppColor.driverPrimaryGradient,
    secondaryGradient: AppColor.driverSecondaryGradient,

    // Primary color shades
    primaryColor950: AppColor.driverButtonPrimaryEnd,
    primaryColor900: AppColor.driverButtonPrimaryEnd,
    primaryColor800: AppColor.driverButtonPrimaryEnd,
    primaryColor700: AppColor.driverButtonPrimaryStart,
    primaryColor600: AppColor.driverButtonPrimaryStart,
    primaryColor500: AppColor.driverButtonPrimaryStart,
    primaryColor400: AppColor.driverButtonPrimaryStart,
    primaryColor300: AppColor.driverBorder,
    primaryColor200: AppColor.driverBorder,
    primaryColor100: AppColor.driverBorder,
    primaryColor75: AppColor.driverInactive,
    primaryColor50: AppColor.driverInactive,
    primaryColor25: AppColor.driverInactive,

    // Black color shades
    blackColor950: AppColor.driverTextSecondary,
    blackColor900: AppColor.driverTextSecondary,
    blackColor800: AppColor.driverTextSecondary,
    blackColor700: AppColor.driverTextSecondary,
    blackColor600: AppColor.driverTextSecondary,
    blackColor500: AppColor.driverTextSecondary,
    blackColor400: AppColor.driverTextSecondary,
    blackColor300: AppColor.driverTextSecondary,
    blackColor200: AppColor.driverTextSecondary,
    blackColor100: AppColor.driverTextSecondary,
    blackColor50: AppColor.driverTextSecondary,

    // Error color shades
    errorColor900: AppColor.errorColor900,
    errorColor800: AppColor.errorColor800,
    errorColor700: AppColor.errorColor700,
    errorColor600: AppColor.errorColor600,
    errorColor500: AppColor.errorColor500,
    errorColor400: AppColor.errorColor400,
    errorColor300: AppColor.errorColor300,
    errorColor200: AppColor.errorColor200,
    errorColor100: AppColor.errorColor100,
    errorColor50: AppColor.errorColor50,
    errorColor25: AppColor.errorColor25,

    // Button properties
    primaryBtn: AppColor.driverButtonPrimaryStart,
    secondaryBtn: AppColor.driverButtonPrimaryEnd,
    btnIcon2: AppColor.driverMobileIcon,
    btnIcon: AppColor.driverMobileIcon,
    btnText: AppColor.driverTextPrimary,
    filledText: AppColor.driverTextPrimary,

    // Text color properties
    secondaryTitleColor: AppColor.driverTextSecondary,
    secondarySubTitleColor: AppColor.driverTextSecondary,
    primaryButtonGradient: AppColor.driverPrimaryButtonGradient,
    secondaryButtonGradient: AppColor.driverSecondaryButtonGradient,
    strokePrimary: AppColor.driverStrokePrimary,
  );
}
