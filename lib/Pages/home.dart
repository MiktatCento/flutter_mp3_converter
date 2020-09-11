import 'package:flutter/material.dart';
import 'package:flutter_mp3_converter/Models/resultModel.dart';
import 'package:flutter_mp3_converter/Widgets/loadedScreen.dart';
import 'package:flutter_mp3_converter/Widgets/mainScreen.dart';
import 'package:flutter_mp3_converter/Widgets/progressScreen.dart';
import 'package:flutter_mp3_converter/backend/api.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController videoURL = new TextEditingController();
  Result _result;
  bool isLoading = false, isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBar(),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromARGB(255, 30, 30, 30),
        child: Center(
          child: isLoading
              ? ProgressScreen()
              : isLoaded
                  ? LoadedScreen(
                      result: _result,
                    )
                  : MainScreen(),
        ),
      ),
    );
  }

  void getData(String _) async {
    try {
      setState(() {
        isLoading = true;
      });
      await API().fetchData(videoURL.text).then((value) {
        setState(() {
          _result = value;
          print(_result.vidTitle);
          isLoading = false;
          isLoaded = true;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        Toast.show(
          e.toString(),
          context,
          duration: 2,
          backgroundColor: Colors.red[300],
          textColor: Colors.black,
          gravity: Toast.BOTTOM,
        );
      });
    }
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: TextFormField(
              controller: videoURL,
              style: TextStyle(color: Colors.white),
              onFieldSubmitted: getData,
              decoration: InputDecoration(
                hintText: "Video URL ...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white70),
                icon: IconButton(
                  onPressed: () {
                    getData("");
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
