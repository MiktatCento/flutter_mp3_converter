import 'dart:convert';

import 'package:flutter_mp3_converter/Models/resultModel.dart';
import 'package:http/http.dart' as http;

class API {
  Result result;
  static String convertUrlToId(String url, {bool trimWhitespaces = true}) {
    assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  Future<Result> fetchData(String ytUrl) async {
    //final querystring = {"stime": "00%3A01%3A00"};
    final headers = {
      'x-rapidapi-host': "download-video-youtube1.p.rapidapi.com",
      'x-rapidapi-key': "26d5f5e1e2mshedcd04dc59ea94fp1fe357jsnbfab3ecb09ba"
    };
    final response = await http.get(
        'https://download-video-youtube1.p.rapidapi.com/mp3/${convertUrlToId(ytUrl)}',
        headers: headers);
    if (response.statusCode == 200) {
      return Result.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
