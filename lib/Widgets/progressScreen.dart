import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text(
            'Veriler Getiriliyor ...',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        )
      ],
    );
  }
}
