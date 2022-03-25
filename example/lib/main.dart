import 'package:flutter/material.dart';
import 'package:ncscolor/ncscolor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("NCS-Color"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("NCS : '2060-R60B' ",),
            Text("ncs to rgp : ${NCSColor(ncsCode: '2060-R60B').toRgb()}"),
            Text("ncs to hsl : ${NCSColor(ncsCode: '2060-R60B').toHsl()}"),
            Text("ncs to hex : ${NCSColor(ncsCode: '2060-R60B').toHex()}"),
            const Divider(),
            const Text("RGB(r: 164,b: 58,g:214)",),
            Text("rgb to hsl : ${ColorConvert.rgbToHsl(r: 164,b: 58,g:214)}"),
            Text("rgb to hex : ${ColorConvert.rgbToHex(r: 164,b: 58,g:214)}"),

          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
