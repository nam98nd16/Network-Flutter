import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Response<Map<String, dynamic>> response;
  var dio = Dio();
  bool didInit = false;

  @override
  void initState() {
    super.initState();
    getForecastData();
  }

  Future<void> getForecastData() async {
    response = await dio.get('http://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': "Hanoi",
          'appid': '454cbe5aa99a99f9d2b63aba7b357a61'
        });
    didInit = true;
    setState(() {});
  }

  Map<String, dynamic> get weatherData {
    return didInit ? jsonDecode(response.toString()) : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: didInit
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Hanoi weather forecast"),
                  Text("Weather: " + weatherData["weather"][0]["description"]),
                  Text("Temperature: " +
                      "${weatherData['main']['temp'] - 273.15}"),
                  Text("Feels like: " +
                      "${weatherData['main']['feels_like'] - 273.15}"),
                  Text("Humidity: " + "${weatherData['main']['humidity']}%")
                ],
              )
            : Container(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
