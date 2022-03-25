class ColorConvert{

  /// to convert ncs rgb to hsl
  static Map<String,String> rgbToHsl({required int r,required int g,required int b}) {
    // ignore: prefer_typing_uninitialized_variables
    var min, max, i, l, s, maxcolor, h, rgb = [];
    rgb = [r / 255 , g / 255 ,  b / 255 ];

    min = rgb[0];
    max = rgb[0];
    maxcolor = 0;
    for (i = 0; i < rgb.length - 1; i++) {
      if (rgb[i + 1] <= min) {min = rgb[i + 1];}
      if (rgb[i + 1] >= max) {max = rgb[i + 1];maxcolor = i + 1;}
    }
    if (maxcolor == 0) {
      h = (rgb[1] - rgb[2]) / (max - min);
    }
    if (maxcolor == 1) {
      h = 2 + (rgb[2] - rgb[0]) / (max - min);
    }
    if (maxcolor == 2) {
      h = 4 + (rgb[0] - rgb[1]) / (max - min);
    }
    if (h == null) {h = 0;}
    h = h * 60;
    if (h < 0) {h = h + 360; }
    l = (min + max) / 2;
    if (min == max) {
      s = 0;
    } else {
      if (l < 0.5) {
        s = (max - min) / (max + min);
      } else {
        s = (max - min) / (2 - max - min);
      }
    }
    s = s;
    return {"h" : h.round().toString(), "s" : "${(s*100).round()}%", "l" : "${(l*100).round()}%"};
  }

  /// to convert ncs rgb to hex
  static String rgbToHex({required int r,required int g,required int b}) {
    var hex = "#${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}";
    return hex;
  }

}