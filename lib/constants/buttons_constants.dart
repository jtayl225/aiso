enum ButtonSize { small, medium, large }

class ButtonDimensions {
  static const double smallWidth = 150.0;
  static const double mediumWidth = 250.0;
  static const double largeWidth = 300.0;

  static const double smallHeight = 40.0;
  static const double mediumHeight = 50.0;
  static const double largeHeight = 60.0;

  // Get the width based on button size
  static double getWidth(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return smallWidth;
      case ButtonSize.medium:
        return mediumWidth;
      case ButtonSize.large:
        return largeWidth;
    }
  }

  // Get the height based on button size
  static double getHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return smallHeight;
      case ButtonSize.medium:
        return mediumHeight;
      case ButtonSize.large:
        return largeHeight;
    }
  }
}