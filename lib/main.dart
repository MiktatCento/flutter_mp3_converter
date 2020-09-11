import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mp3_converter/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube MP3 Çevirici',
      locale: Locale('tr', 'TR'),
      color: Color.fromARGB(255, 30, 30, 30),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr'),
        const Locale('en'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.red[400],
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
