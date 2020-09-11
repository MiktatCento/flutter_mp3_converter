class Result {
  String vidID;
  String vidTitle;
  String vidThumb;
  int duration;
  Map vidInfo;

  Result(
      {this.vidID, this.vidTitle, this.vidThumb, this.duration, this.vidInfo});

  Result.fromJson(Map<String, dynamic> json) {
    vidID = json['vidID'];
    vidTitle = json['vidTitle'];
    vidThumb = json['vidThumb'];
    duration = json['duration'];
    vidInfo = json['vidInfo']["1"] ?? json['vidInfo']["0"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vidID'] = this.vidID;
    data['vidTitle'] = this.vidTitle;
    data['vidThumb'] = this.vidThumb;
    data['duration'] = this.duration;
    data['vidInfo'] = this.vidInfo;
    return data;
  }
}
