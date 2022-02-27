import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_streaming_app/model/element.dart';
import 'package:movie_streaming_app/utils/renderTreeScraper.dart';
import 'package:movie_streaming_app/views/movie_screen.dart';

import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _startServer(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xff091A2A),
        accentColor: Color(0xffE50914),
        fontFamily: 'Poppins',
      ),
      home: HomePage(),
    );
  }

  void _startServer(BuildContext context) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    print("Server running on IP : " +
        server.address.toString() +
        " On Port : " +
        server.port.toString());
    await for (final request in server) {
      var statusCode = 405;
      var responseJson =
          '{"code": 405, "message": "No route found for \'${request.method} ${request.uri.path}\': Method Not Allowed"}';
      if (request.method == "GET" &&
          request.uri.path == "/getCurrentWidgetTree") {
        statusCode = 200;
        responseJson = RenderTreeScraper().scrapeData(context);
        //mockedData "[{top: 50.0, left: 66.95954487989886, width: 256.0809102402023, height: 337.6, color: #ffffffff}, {top: 397.6, left: 35.0, width: 105.0, height: 39.0, color: #ffffffff}]"; // eg. ;
      }

      request.response
        ..statusCode = statusCode
        ..headers.contentType =
            ContentType("application", "json", charset: "utf-8")
        ..write(responseJson)
        ..close();
    }
  }
}
