class ColorConvert {
  /// Converts RGB values to HSL format
  ///
  /// Takes RGB values [r], [g], [b] in range 0-255
  /// Returns a Map with keys 'h' (hue), 's' (saturation %), 'l' (lightness %)
  static Map<String, String> rgbToHsl({
    required int r,
    required int g,
    required int b,
  }) {
    // Normalize RGB values to 0-1 range
    double rNorm = r / 255.0;
    double gNorm = g / 255.0;
    double bNorm = b / 255.0;

    double min = [rNorm, gNorm, bNorm].reduce((a, b) => a < b ? a : b);
    double max = [rNorm, gNorm, bNorm].reduce((a, b) => a > b ? a : b);
    double delta = max - min;

    // Calculate lightness
    double lightness = (min + max) / 2;

    double hue = 0;
    double saturation = 0;

    if (delta != 0) {
      // Calculate saturation
      saturation =
          lightness < 0.5 ? delta / (max + min) : delta / (2 - max - min);

      // Calculate hue
      if (max == rNorm) {
        hue = ((gNorm - bNorm) / delta) % 6;
      } else if (max == gNorm) {
        hue = (bNorm - rNorm) / delta + 2;
      } else {
        hue = (rNorm - gNorm) / delta + 4;
      }
      hue *= 60;
      if (hue < 0) hue += 360;
    }

    return {
      "h": hue.round().toString(),
      "s": "${(saturation * 100).round()}%",
      "l": "${(lightness * 100).round()}%"
    };
  }

  /// Converts RGB values to HEX format
  ///
  /// Takes RGB values [r], [g], [b] in range 0-255
  /// Returns a hex string in format #RRGGBB
  static String rgbToHex({
    required int r,
    required int g,
    required int b,
  }) {
    // Ensure values are within valid range
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    // Convert to hex with proper padding
    String rHex = r.toRadixString(16).padLeft(2, '0');
    String gHex = g.toRadixString(16).padLeft(2, '0');
    String bHex = b.toRadixString(16).padLeft(2, '0');

    return "#$rHex$gHex$bHex";
  }
}
