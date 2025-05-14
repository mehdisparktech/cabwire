import 'package:flutter/material.dart';
import 'package:cabwire/core/config/app_screen.dart';

class CustomText extends StatelessWidget {
  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.softWrap,
  });

  final String text;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle defaultStyle =
        theme.textTheme.bodyMedium ?? const TextStyle();

    return Text(
      text,
      style:
          style?.copyWith(
            fontSize: fontSize ?? style?.fontSize,
            fontWeight: fontWeight ?? style?.fontWeight,
            color: color ?? style?.color,
            letterSpacing: letterSpacing ?? style?.letterSpacing,
            height: height ?? style?.height,
            decoration: decoration ?? style?.decoration,
            decorationColor: decorationColor ?? style?.decorationColor,
            decorationStyle: decorationStyle ?? style?.decorationStyle,
            decorationThickness:
                decorationThickness ?? style?.decorationThickness,
          ) ??
          defaultStyle.copyWith(
            fontSize: fontSize ?? fourteenPx,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: letterSpacing,
            height: height,
            decoration: decoration,
            decorationColor: decorationColor,
            decorationStyle: decorationStyle,
            decorationThickness: decorationThickness,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

// Predefined text styles for common use cases
class TextStyles {
  // Headings
  static CustomText h1(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    FontWeight fontWeight = FontWeight.bold,
    double? fontSize,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? twentyFourPx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static CustomText h2(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    FontWeight fontWeight = FontWeight.bold,
    double? fontSize,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? twentyPx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static CustomText h3(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    FontWeight fontWeight = FontWeight.w600,
    double? fontSize,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? eighteenPx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Body text
  static CustomText body(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    FontWeight fontWeight = FontWeight.normal,
    double? fontSize,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? fourteenPx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Small text
  static CustomText small(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    FontWeight fontWeight = FontWeight.normal,
    double? fontSize,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? twelvePx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  // Button text
  static CustomText button(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign = TextAlign.center,
    FontWeight fontWeight = FontWeight.w500,
    double? fontSize,
  }) {
    return CustomText(
      text,
      key: key,
      fontSize: fontSize ?? fourteenPx,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
    );
  }
}
