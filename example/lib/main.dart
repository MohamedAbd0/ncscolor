import 'package:flutter/material.dart';
import 'package:ncscolor/ncscolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCS Color Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller =
      TextEditingController(text: '2060-R60B');
  String _currentNCS = '2060-R60B';
  Map<String, int>? _rgbResult;
  Map<String, String>? _hslResult;
  String? _hexResult;
  Color? _colorPreview;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _convertColor();
  }

  void _convertColor() {
    setState(() {
      _errorMessage = null;
      try {
        final ncsColor = NCSColor(ncsCode: _currentNCS);
        _rgbResult = ncsColor.toRgb();
        _hslResult = ncsColor.toHsl();
        _hexResult = ncsColor.toHex();
        _colorPreview = Color.fromRGBO(
          _rgbResult!['r']!,
          _rgbResult!['g']!,
          _rgbResult!['b']!,
          1.0,
        );
      } catch (e) {
        _errorMessage = e.toString();
        _rgbResult = null;
        _hslResult = null;
        _hexResult = null;
        _colorPreview = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NCS Color Converter"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NCS Color Input',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter NCS Color Code',
                        hintText: 'e.g., 2060-R60B',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _currentNCS = value;
                        _convertColor();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (_colorPreview != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Color Preview',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: _colorPreview,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conversion Results',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildResultRow('NCS', _currentNCS),
                      _buildResultRow('RGB',
                          'R:${_rgbResult!['r']}, G:${_rgbResult!['g']}, B:${_rgbResult!['b']}'),
                      _buildResultRow('HSL',
                          'H:${_hslResult!['h']}, S:${_hslResult!['s']}, L:${_hslResult!['l']}'),
                      _buildResultRow('HEX', _hexResult!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RGB to HSL/HEX Conversion',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildResultRow('RGB Input', 'R:164, G:58, B:214'),
                      _buildResultRow(
                          'To HSL',
                          ColorConvert.rgbToHsl(r: 164, g: 58, b: 214)
                              .toString()),
                      _buildResultRow('To HEX',
                          ColorConvert.rgbToHex(r: 164, g: 58, b: 214)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
