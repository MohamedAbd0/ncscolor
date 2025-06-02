# API Documentation

## Classes

### NCSColor

The main class for handling NCS (Natural Color System) color conversions.

#### Constructor

```dart
NCSColor({required String ncsCode})
```

Creates an NCSColor instance with the given NCS color code.

**Parameters:**

- `ncsCode` (String): The NCS color code in format ####-[RGBY]##[RGBY]]

**Throws:**

- `ArgumentError`: If the NCS code format is invalid

#### Methods

##### toRgb()

```dart
Map<String, int> toRgb()
```

Converts the NCS color code to RGB values.

**Returns:**

- `Map<String, int>`: A map with keys 'r', 'g', 'b' containing integer values (0-255)

**Example:**

```dart
final ncsColor = NCSColor(ncsCode: '2060-R60B');
final rgb = ncsColor.toRgb(); // {r: 164, g: 58, b: 214}
```

##### toHsl()

```dart
Map<String, String> toHsl()
```

Converts the NCS color code to HSL format.

**Returns:**

- `Map<String, String>`: A map with keys 'h' (hue), 's' (saturation %), 'l' (lightness %)

**Example:**

```dart
final ncsColor = NCSColor(ncsCode: '2060-R60B');
final hsl = ncsColor.toHsl(); // {h: 281, s: 66%, l: 53%}
```

##### toHex()

```dart
String toHex()
```

Converts the NCS color code to HEX format.

**Returns:**

- `String`: A hex color code in format #RRGGBB

**Example:**

```dart
final ncsColor = NCSColor(ncsCode: '2060-R60B');
final hex = ncsColor.toHex(); // #a43ad6
```

##### toString()

```dart
String toString()
```

Returns a string representation of the NCS color.

**Returns:**

- `String`: String in format 'NCSColor(ncsCode)'

##### operator ==

```dart
bool operator ==(Object other)
```

Checks if two NCS colors are equal.

**Parameters:**

- `other` (Object): The object to compare with

**Returns:**

- `bool`: True if the NCS codes are equal, false otherwise

##### hashCode

```dart
int get hashCode
```

Returns the hash code for this NCS color.

**Returns:**

- `int`: Hash code based on the NCS code

### ColorConvert

A utility class for RGB color conversions.

#### Static Methods

##### rgbToHsl()

```dart
static Map<String, String> rgbToHsl({
  required int r,
  required int g,
  required int b,
})
```

Converts RGB values to HSL format.

**Parameters:**

- `r` (int): Red value (0-255)
- `g` (int): Green value (0-255)
- `b` (int): Blue value (0-255)

**Returns:**

- `Map<String, String>`: A map with keys 'h' (hue), 's' (saturation %), 'l' (lightness %)

**Example:**

```dart
final hsl = ColorConvert.rgbToHsl(r: 164, g: 58, b: 214);
// {h: 281, s: 66%, l: 53%}
```

##### rgbToHex()

```dart
static String rgbToHex({
  required int r,
  required int g,
  required int b,
})
```

Converts RGB values to HEX format.

**Parameters:**

- `r` (int): Red value (0-255)
- `g` (int): Green value (0-255)
- `b` (int): Blue value (0-255)

**Returns:**

- `String`: A hex color code in format #RRGGBB

**Example:**

```dart
final hex = ColorConvert.rgbToHex(r: 164, g: 58, b: 214);
// #a43ad6
```

**Note:** RGB values outside the 0-255 range are automatically clamped to valid values.

## Error Handling

The package provides proper error handling for invalid inputs:

### Invalid NCS Format

When an invalid NCS color code is provided, an `ArgumentError` is thrown with a descriptive message:

```dart
try {
  final ncsColor = NCSColor(ncsCode: 'invalid-format');
  final rgb = ncsColor.toRgb();
} catch (e) {
  print(e); // ArgumentError: Invalid NCS color format...
}
```

### Valid NCS Formats

The following NCS formats are supported:

- `####-R` - Pure red hue
- `####-G` - Pure green hue
- `####-B` - Pure blue hue
- `####-Y` - Pure yellow hue
- `####-R##B` - Red-blue mix
- `####-R##G` - Red-green mix
- `####-G##B` - Green-blue mix
- `####-G##Y` - Green-yellow mix
- `####-B##R` - Blue-red mix
- `####-B##G` - Blue-green mix
- `####-Y##R` - Yellow-red mix
- `####-Y##G` - Yellow-green mix

Where:

- `####` represents blackness (first 2 digits) and chromaticness (last 2 digits)
- `##` represents the percentage of the secondary hue (00-99)

## Constants and Limits

- RGB values: 0-255
- Hue: 0-360 degrees
- Saturation: 0-100%
- Lightness: 0-100%
- Blackness (NCS): 0-99
- Chromaticness (NCS): 0-99
- Hue percentage (NCS): 0-99
