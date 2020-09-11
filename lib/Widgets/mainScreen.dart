import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Youtube MP3 Çevirici",
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          "Miktat Cento Tarafından Geliştirildi!",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        Icon(
          FontAwesomeIcons.youtube,
          color: Colors.redAccent,
          size: 45.0,
        ),
      ],
    );
  }
}
