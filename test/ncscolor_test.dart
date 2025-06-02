import 'package:flutter_test/flutter_test.dart';
import 'package:ncscolor/ncscolor.dart';

void main() {
  group('NCSColor Tests', () {
    test('should convert NCS to RGB correctly', () {
      final ncsColor = NCSColor(ncsCode: '2060-R60B');
      final rgb = ncsColor.toRgb();

      expect(rgb['r'], isA<int>());
      expect(rgb['g'], isA<int>());
      expect(rgb['b'], isA<int>());
      expect(rgb['r']! >= 0 && rgb['r']! <= 255, true);
      expect(rgb['g']! >= 0 && rgb['g']! <= 255, true);
      expect(rgb['b']! >= 0 && rgb['b']! <= 255, true);
    });

    test('should convert NCS to HSL correctly', () {
      final ncsColor = NCSColor(ncsCode: '2060-R60B');
      final hsl = ncsColor.toHsl();

      expect(hsl['h'], isA<String>());
      expect(hsl['s'], isA<String>());
      expect(hsl['l'], isA<String>());
      expect(hsl['s']!.endsWith('%'), true);
      expect(hsl['l']!.endsWith('%'), true);
    });

    test('should convert NCS to HEX correctly', () {
      final ncsColor = NCSColor(ncsCode: '2060-R60B');
      final hex = ncsColor.toHex();

      expect(hex.startsWith('#'), true);
      expect(hex.length, 7);
      expect(RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(hex), true);
    });

    test('should throw error for invalid NCS format', () {
      expect(() => NCSColor(ncsCode: 'invalid').toRgb(), throwsArgumentError);
      expect(() => NCSColor(ncsCode: '123-R').toRgb(), throwsArgumentError);
      expect(
          () => NCSColor(ncsCode: '12345-R60B').toRgb(), throwsArgumentError);
    });

    test('should handle valid NCS formats', () {
      expect(() => NCSColor(ncsCode: '2060-R60B').toRgb(), returnsNormally);
      expect(() => NCSColor(ncsCode: '1050-Y90R').toRgb(), returnsNormally);
      expect(() => NCSColor(ncsCode: '0505-B').toRgb(), returnsNormally);
      expect(() => NCSColor(ncsCode: '9999-G').toRgb(), returnsNormally);
    });

    test('should implement toString correctly', () {
      final ncsColor = NCSColor(ncsCode: '2060-R60B');
      expect(ncsColor.toString(), 'NCSColor(2060-R60B)');
    });

    test('should implement equality correctly', () {
      final ncsColor1 = NCSColor(ncsCode: '2060-R60B');
      final ncsColor2 = NCSColor(ncsCode: '2060-R60B');
      final ncsColor3 = NCSColor(ncsCode: '1050-Y90R');

      expect(ncsColor1 == ncsColor2, true);
      expect(ncsColor1 == ncsColor3, false);
      expect(ncsColor1.hashCode == ncsColor2.hashCode, true);
    });
  });

  group('ColorConvert Tests', () {
    test('should convert RGB to HSL correctly', () {
      final hsl = ColorConvert.rgbToHsl(r: 164, g: 58, b: 214);

      expect(hsl['h'], isA<String>());
      expect(hsl['s'], isA<String>());
      expect(hsl['l'], isA<String>());
      expect(hsl['s']!.endsWith('%'), true);
      expect(hsl['l']!.endsWith('%'), true);

      // Test specific values
      expect(int.parse(hsl['h']!) >= 0 && int.parse(hsl['h']!) <= 360, true);
    });

    test('should convert RGB to HEX correctly', () {
      final hex = ColorConvert.rgbToHex(r: 164, g: 58, b: 214);

      expect(hex.startsWith('#'), true);
      expect(hex.length, 7);
      expect(RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(hex), true);
    });

    test('should handle edge RGB values', () {
      // Test with minimum values
      expect(() => ColorConvert.rgbToHex(r: 0, g: 0, b: 0), returnsNormally);
      expect(ColorConvert.rgbToHex(r: 0, g: 0, b: 0), '#000000');

      // Test with maximum values
      expect(
          () => ColorConvert.rgbToHex(r: 255, g: 255, b: 255), returnsNormally);
      expect(ColorConvert.rgbToHex(r: 255, g: 255, b: 255), '#ffffff');

      // Test with values that need padding
      expect(ColorConvert.rgbToHex(r: 1, g: 2, b: 3), '#010203');
    });

    test('should handle RGB values outside range gracefully', () {
      // Values should be clamped to valid range
      expect(
          () => ColorConvert.rgbToHex(r: -10, g: 300, b: 256), returnsNormally);
      expect(ColorConvert.rgbToHex(r: -10, g: 300, b: 256), '#00ffff');
    });
  });
}
