import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Font sizes for mobile and desktop
class FontSizes {
  // Desktop
  static const double desktopH1 = 36;
  static const double desktopH2 = 26;
  static const double desktopH3 = 20;
  static const double desktopBody = 14;

  // Mobile
  static const double mobileH1 = 26;
  static const double mobileH2 = 20;
  static const double mobileH3 = 16;
  static const double mobileBody = 12;
}

/// Responsive font styles using FontSizes
class AppTextStyles {
  static TextStyle h1(DeviceScreenType device) => TextStyle(
        fontSize: _fontSize(device, FontSizes.desktopH1, FontSizes.mobileH1),
        fontWeight: FontWeight.bold,
      );

  static TextStyle h2(DeviceScreenType device) => TextStyle(
        fontSize: _fontSize(device, FontSizes.desktopH2, FontSizes.mobileH2),
        fontWeight: FontWeight.w600,
      );

  static TextStyle h3(DeviceScreenType device) => TextStyle(
        fontSize: _fontSize(device, FontSizes.desktopH3, FontSizes.mobileH3),
        fontWeight: FontWeight.w500,
      );

  static TextStyle body(DeviceScreenType device) => TextStyle(
        fontSize: _fontSize(device, FontSizes.desktopBody, FontSizes.mobileBody),
        fontWeight: FontWeight.normal,
      );

  static double _fontSize(DeviceScreenType device, double desktop, double mobile) {
    return device == DeviceScreenType.desktop ? desktop : mobile;
  }
}

/// Responsive spacing values for vertical layout structure
class ResponsiveSpacing {
  static double headingMarginBottom(DeviceScreenType device) {
    return device == DeviceScreenType.desktop ? 32.0 : 16.0;
  }

  static double paragraphSpacing(DeviceScreenType device) {
    return device == DeviceScreenType.desktop ? 20.0 : 12.0;
  }

  static double sectionPadding(DeviceScreenType device) {
    return device == DeviceScreenType.desktop ? 48.0 : 24.0;
  }

  static double horizontalGutter(DeviceScreenType device) {
    return device == DeviceScreenType.desktop ? 32.0 : 16.0;
  }
}
