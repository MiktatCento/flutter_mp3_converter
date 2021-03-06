import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mp3_converter/Backend/api.dart';
import 'package:flutter_mp3_converter/Models/resultModel.dart';
import 'package:flutter_mp3_converter/Service/permissionsService.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:toast/toast.dart';
import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';

class LoadedScreen extends StatefulWidget {
  final Result result;
  LoadedScreen({@required this.result});

  @override
  _LoadedScreenState createState() => _LoadedScreenState();
}

class _LoadedScreenState extends State<LoadedScreen> {
  bool isDownloading = false;
  bool downloadsuccess = false;
  String status = "İndir";
  String progress = "%0";
  List<StorageInfo> _storageInfo = [];

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}
    if (!mounted) return;
    setState(() {
      _storageInfo = storageInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> downloadVideo(
        String trackURL, String trackName, String format) async {
      Audiotagger tagger = new Audiotagger();
      try {
        trackName = trackName.replaceAll(RegExp("/"), "");
        if (await PermissionsService().requestStoragePermission()) {
          setState(() {
            isDownloading = true;
            downloadsuccess = false;
            status = "İndiriliyor";
          });
          Dio dio = Dio();
          var directory = _storageInfo.first.rootDir + "/Müzikler/";
          var path = "$directory" + trackName + format;
          print(path);
          await dio.download(trackURL, path, onReceiveProgress: (rec, total) {
            Toast.show(
              API().formatBytes(rec, 2),
              context,
              duration: 2,
              backgroundColor: Colors.green,
              textColor: Colors.black,
              gravity: Toast.BOTTOM,
            );
          });
          final tag = Tag(
            artist: "IG: @miktat0",
            album: "Youtube MP3 Çevirici", //This field will be reset
          );
          final result = await tagger.writeTags(
            path: path,
            tag: tag,
          );

          setState(() {
            isDownloading = false;
            downloadsuccess = true;
            status = "İndirildi";
          });
          Toast.show(
            "İndirildi",
            context,
            duration: 5,
            backgroundColor: Colors.green,
            textColor: Colors.black,
            gravity: Toast.BOTTOM,
          );
        } else {
          Toast.show(
            "İzin reddedildi, lütfen tekrar indiriniz.",
            context,
            duration: 2,
            backgroundColor: Colors.redAccent,
            textColor: Colors.black,
            gravity: Toast.BOTTOM,
          );
        }
      } catch (e) {
        setState(() {
          isDownloading = false;
          status = "ERROR";
        });
        Toast.show(
          e.toString(),
          context,
          duration: 2,
          backgroundColor: Colors.red[300],
          textColor: Colors.black,
          gravity: Toast.BOTTOM,
        );
      }
    }

    Widget labelTitle(String title, String inpute) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(
              inpute,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(19.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                    image: NetworkImage(widget.result.vidThumb),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              labelTitle("Başlık : ", widget.result.vidTitle),
              SizedBox(
                height: 8.0,
              ),
              labelTitle(
                  "Süre : ",
                  API().printDuration(
                      Duration(seconds: widget.result.duration))),
              SizedBox(
                height: 5.0,
              ),
              labelTitle("Boyut : ", widget.result?.vidInfo["mp3size"]),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 40.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color:
                      downloadsuccess == true ? Colors.green : Colors.redAccent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      50.0,
                    ),
                  ),
                ),
                child: FlatButton(
                  onPressed: () {
                    !downloadsuccess
                        ? !isDownloading
                            ? downloadVideo(widget.result.vidInfo["dloadUrl"],
                                widget.result.vidTitle, ".mp3")
                            : API().nothingHere(context)
                        : API().nothingHere(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        status,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      isDownloading
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              ),
                            )
                          : Icon(
                              downloadsuccess
                                  ? FontAwesomeIcons.check
                                  : FontAwesomeIcons.download,
                              color: Colors.black,
                              size: 20.0,
                            )
                    ],
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  progress,
                  style: TextStyle(color: Colors.white),
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}
