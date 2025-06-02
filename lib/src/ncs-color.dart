import 'dart:math' as math;
import 'color-convert.dart';

/// A class to handle NCS (Natural Color System) color conversions
///
/// NCS is a proprietary color system based on the color opponency hypothesis
/// of color vision. It describes colors in terms of blackness, chromaticness,
/// and hue components.
class NCSColor {
  /// The NCS color code (e.g., '2060-R60B')
  final String ncsCode;

  /// Creates an NCSColor instance with the given [ncsCode]
  ///
  /// The NCS code should be in the format ####-[RGBY][##[RGBY]]
  /// Examples: '2060-R60B', '1050-Y90R', '0505-B'
  NCSColor({required this.ncsCode});

  /// Converts NCS color code to RGB values
  ///
  /// Returns a Map with keys 'r', 'g', 'b' containing integer values (0-255)
  ///
  /// Throws [ArgumentError] if the NCS code format is invalid
  Map<String, int> toRgb() {
    // Validate NCS color format
    final RegExp regExp = RegExp(
      r"^\d{4}-[RGBY](\d{2}[RGBY])?$",
      caseSensitive: false,
    );

    if (!regExp.hasMatch(ncsCode.toUpperCase())) {
      throw ArgumentError(
          'Invalid NCS color format. Expected format: ####-[RGBY][##[RGBY]]\n'
          'Example: 2060-R60B');
    }

    // Parse NCS components
    final String ncs = ncsCode.toUpperCase();
    final List<String> parts = ncs.split("-");

    final int black = int.parse(parts[0].substring(0, 2));
    final int chroma = int.parse(parts[0].substring(2));
    final String bc = parts[1].substring(0, 1);
    final int percent =
        parts[1].length > 2 ? int.parse(parts[1].substring(1, 3)) : 0;

    late int r, g, b;

    if (bc != 'N') {
      final double black1 = (1.05 * black - 5.25);
      final double chroma1 = chroma.toDouble();

      double red1 = _calculateRed(bc, percent);
      double blue1 = _calculateBlue(bc, percent);
      double green1 = _calculateGreen(bc, percent);

      final double factor1 = (red1 + green1 + blue1) / 3;
      final double red2 = ((factor1 - red1) * (100 - chroma1) / 100) + red1;
      final double green2 =
          ((factor1 - green1) * (100 - chroma1) / 100) + green1;
      final double blue2 = ((factor1 - blue1) * (100 - chroma1) / 100) + blue1;

      double max = [red2, green2, blue2].reduce(math.max);
      if (max == 0) max = (red2 + green2 + blue2) / 3;

      final double factor2 = 1 / max;
      r = ((red2 * factor2 * (100 - black1) / 100) * 255).round().clamp(0, 255);
      g = ((green2 * factor2 * (100 - black1) / 100) * 255)
          .round()
          .clamp(0, 255);
      b = ((blue2 * factor2 * (100 - black1) / 100) * 255)
          .round()
          .clamp(0, 255);
    } else {
      // Handle grayscale (N) colors
      final int grey = ((1 - black / 100) * 255).round().clamp(0, 255);
      r = g = b = grey;
    }

    return {"r": r, "g": g, "b": b};
  }

  /// Helper method to calculate red component
  double _calculateRed(String bc, int percent) {
    switch (bc) {
      case 'Y':
        if (percent <= 60) return 1.0;
        final double factor1 = percent - 60;
        return ((math.sqrt(14884 - math.pow(factor1, 2))) - 22) / 100;
      case 'R':
        if (percent <= 80) {
          final double factor1 = percent + 40;
          return ((math.sqrt(14884 - math.pow(factor1, 2))) - 22) / 100;
        }
        return 0.0;
      case 'B':
        return 0.0;
      case 'G':
        final double factor1 = percent - 170;
        return ((math.sqrt(33800 - math.pow(factor1, 2))) - 70) / 100;
      default:
        return 0.0;
    }
  }

  /// Helper method to calculate blue component
  double _calculateBlue(String bc, int percent) {
    switch (bc) {
      case 'Y':
        if (percent <= 80) return 0.0;
        final double factor1 = (percent - 80) + 20.5;
        return (104 - (math.sqrt(11236 - math.pow(factor1, 2)))) / 100;
      case 'R':
        if (percent <= 60) {
          final double factor1 = (percent + 20) + 20.5;
          return (104 - (math.sqrt(11236 - math.pow(factor1, 2)))) / 100;
        }
        final double factor1 = (percent - 60) - 60;
        return ((math.sqrt(10000 - math.pow(factor1, 2))) - 10) / 100;
      case 'B':
        if (percent <= 80) {
          final double factor1 = (percent + 40) - 60;
          return ((math.sqrt(10000 - math.pow(factor1, 2))) - 10) / 100;
        }
        final double factor1 = (percent - 80) - 131;
        return (122 - (math.sqrt(19881 - math.pow(factor1, 2)))) / 100;
      case 'G':
        if (percent <= 40) {
          final double factor1 = (percent + 20) - 131;
          return (122 - (math.sqrt(19881 - math.pow(factor1, 2)))) / 100;
        }
        return 0.0;
      default:
        return 0.0;
    }
  }

  /// Helper method to calculate green component
  double _calculateGreen(String bc, int percent) {
    switch (bc) {
      case 'Y':
        return (85 - 17 / 20 * percent) / 100;
      case 'R':
        if (percent <= 60) return 0.0;
        final double factor1 = (percent - 60) + 35;
        return (67.5 - (math.sqrt(5776 - math.pow(factor1, 2)))) / 100;
      case 'B':
        if (percent <= 60) {
          final double factor1 = (1 * percent - 68.5);
          return (6.5 + (math.sqrt(7044.5 - math.pow(factor1, 2)))) / 100;
        }
        return 0.9;
      case 'G':
        if (percent <= 60) return 0.9;
        final double factor1 = percent - 60;
        return (90 - (1 / 8 * factor1)) / 100;
      default:
        return 0.0;
    }
  }

  /// Converts NCS color code to HSL format
  ///
  /// Returns a Map with keys 'h' (hue), 's' (saturation %), 'l' (lightness %)
  Map<String, String> toHsl() {
    final Map<String, int> rgbColor = toRgb();
    final int r = rgbColor["r"]!;
    final int g = rgbColor["g"]!;
    final int b = rgbColor["b"]!;

    return ColorConvert.rgbToHsl(r: r, g: g, b: b);
  }

  /// Converts NCS color code to HEX format
  ///
  /// Returns a hex string in format #RRGGBB
  String toHex() {
    final Map<String, int> rgbColor = toRgb();
    final int r = rgbColor["r"]!;
    final int g = rgbColor["g"]!;
    final int b = rgbColor["b"]!;
    return ColorConvert.rgbToHex(r: r, g: g, b: b);
  }

  /// Returns a string representation of the NCS color
  @override
  String toString() => 'NCSColor($ncsCode)';

  /// Checks if two NCS colors are equal
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NCSColor &&
          runtimeType == other.runtimeType &&
          ncsCode == other.ncsCode;

  /// Returns the hash code for this NCS color
  @override
  int get hashCode => ncsCode.hashCode;
}
