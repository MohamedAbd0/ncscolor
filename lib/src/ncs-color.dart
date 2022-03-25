import 'dart:math' as math;
import 'color-convert.dart';

class NCSColor{
  final String ncsCode;
  NCSColor({required this.ncsCode});

  /// to convert ncs code to rgb
  Map<String,int> toRgb(){

    /// dddd-[char]dd[chart]
    RegExp regExp = RegExp(
      r"^(.* )?\d{4}-[rgby](\d{2}[rgby])?$",
      caseSensitive: false,
      multiLine: false,
    ) ;

    if(!regExp.hasMatch(ncsCode)){
      throw 'NCS color should be in the form\n####-(RGBY)[##(RGBY)]';
    }

    // ignore: prefer_typing_uninitialized_variables
    var black, chroma, bc, percent, black1, chroma1, red1,green1 , factor1, blue1, red2, green2, blue2, max, factor2, grey, r, g, b;
    String ncs = ncsCode;
    List<dynamic> parts = [];
    parts = ncs.split("-");
    black = int.parse(parts[0].toString().substring(0,2));//parseInt(ncs[1], 10);
    chroma = int.parse(parts[0].toString().substring(2));//pa// rseInt(ncs[2], 10);
    bc = parts[1].toString().substring(0,1);
    //if (bc != "N" && bc != "Y" && bc != "R" && bc != "B" && bc != "G") {return false;}
    percent = parts[1].toString().length > 2 ? int.parse(parts[1].toString().substring(1,3)) : 0;
    if (bc != 'N') {
      black1 = (1.05 * black - 5.25);
      chroma1 = chroma;
      if (bc == 'Y' && percent <= 60) {
        red1 = 1;
      } else if (( bc == 'Y' && percent > 60) || ( bc == 'R' && percent <= 80)) {
        if (bc == 'Y') {
          factor1 = percent - 60;
        } else {
          factor1 = percent + 40;
        }
        red1 = ((math.sqrt(14884 - math.pow(factor1, 2))) - 22) / 100;
      } else if ((bc == 'R' && percent > 80) || (bc == 'B')) {
        red1 = 0;
      } else if (bc == 'G') {
        factor1 = (percent - 170);
        red1 = ((math.sqrt(33800 - math.pow(factor1, 2))) - 70) / 100;
      }
      if (bc == 'Y' && percent <= 80) {
        blue1 = 0;
      } else if (( bc == 'Y' && percent > 80) || ( bc == 'R' && percent <= 60)) {
        if (bc =='Y') {
          factor1 = (percent - 80) + 20.5;
        } else {
          factor1 = (percent + 20) + 20.5;
        }
        blue1 = (104 - (math.sqrt(11236 - math.pow(factor1, 2)))) / 100;
      } else if ((bc == 'R' && percent > 60) || ( bc == 'B' && percent <= 80)) {
        if (bc =='R') {
          factor1 = (percent - 60) - 60;
        } else {
          factor1 = (percent + 40) - 60;
        }
        blue1 = ((math.sqrt(10000 - math.pow(factor1, 2))) - 10) / 100;
      } else if (( bc == 'B' && percent > 80) || ( bc == 'G' && percent <= 40)) {
        if (bc == 'B') {
          factor1 = (percent - 80) - 131;
        } else {
          factor1 = (percent + 20) - 131;
        }
        blue1 = (122 - (math.sqrt(19881 - math.pow(factor1, 2)))) / 100;
      } else if (bc == 'G' && percent > 40) {
        blue1 = 0;
      }
      if (bc == 'Y') {
        green1 = (85 - 17/20 * percent) / 100;
      } else if (bc == 'R' && percent <= 60) {
        green1 = 0;
      } else if (bc == 'R' && percent > 60) {
        factor1 = (percent - 60) + 35;
        green1 = (67.5 - (math.sqrt(5776 - math.pow(factor1, 2)))) / 100;
      } else if (bc == 'B' && percent <= 60) {
        factor1 = (1*percent - 68.5);
        green1 = (6.5 + (math.sqrt(7044.5 - math.pow(factor1, 2)))) / 100;
      } else if ((bc == 'B' && percent > 60) || ( bc == 'G' && percent <= 60)) {
        green1 = 0.9;
      } else if (bc == 'G' && percent > 60) {
        factor1 = (percent - 60);
        green1 = (90 - (1/8 * factor1)) / 100;
      }
      factor1 = (red1 + green1 + blue1)/3;
      red2 = ((factor1 - red1) * (100 - chroma1) / 100) + red1;
      green2 = ((factor1 - green1) * (100 - chroma1) / 100) + green1;
      blue2 = ((factor1 - blue1) * (100 - chroma1) / 100) + blue1;
      if (red2 > green2 && red2 > blue2) {
        max = red2;
      } else if (green2 > red2 && green2 > blue2) {
        max = green2;
      } else if (blue2 > red2 && blue2 > green2) {
        max = blue2;
      } else {
        max = (red2 + green2 + blue2) / 3;
      }
      factor2 = 1 / max;
      r = ((red2 * factor2 * (100 - black1) / 100)* 255).toInt();
      g = ((green2 * factor2 * (100 - black1) / 100) * 255).toInt();
      b = ((blue2 * factor2 * (100 - black1) / 100) * 255).toInt();
      if (r > 255) {r = 255;}
      if (g > 255) {g = 255;}
      if (b > 255) {b = 255;}
      if (r < 0) {r = 0;}
      if (g < 0) {g = 0;}
      if (b < 0) {b = 0;}
    } else {
      grey = int.parse(((1 - black / 100) * 255).toString());
      if (grey > 255) {grey = 255;}
      if (grey < 0) {grey = 0;}
      r = grey;
      g = grey;
      b = grey;
    }
    return {
      "r" : r,
      "g" : g,
      "b" : b
    };
  }

  /// to convert ncs code to hsl
  Map<String,String> toHsl() {
    var rgpColor = toRgb();
    int r =rgpColor["r"]!;
    int g =rgpColor["g"]!;
    int b =rgpColor["b"]!;

    return ColorConvert.rgbToHsl(r: r, g: g, b: b);
  }

  /// to convert ncs code to hex
  String toHex() {
    var rgpColor = toRgb();
    int r = rgpColor["r"]!;
    int g =rgpColor["g"]!;
    int b =rgpColor["b"]!;
    return ColorConvert.rgbToHex(r: r, g: g, b: b);
  }

}


