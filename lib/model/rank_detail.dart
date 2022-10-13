class RankDetailData {
  List<RankDetail>? data;

  RankDetailData({this.data});

  RankDetailData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RankDetail>[];
      json['data'].forEach((v) {
        data!.add(new RankDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RankDetail {
  int? position;
  int? mostRecentPosition;
  User? user;
  int? pointsFromLastRound;
  int? points;

  RankDetail(
      {this.position,
        this.mostRecentPosition,
        this.user,
        this.pointsFromLastRound,
        this.points});

  RankDetail.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    mostRecentPosition = json['most_recent_position'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pointsFromLastRound = json['points_from_last_round'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['most_recent_position'] = this.mostRecentPosition;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['points_from_last_round'] = this.pointsFromLastRound;
    data['points'] = this.points;
    return data;
  }
}

class User {
  int? id;
  String? profilePicture;
  String? username;

  User({this.id, this.profilePicture, this.username});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_picture'] = this.profilePicture;
    data['username'] = this.username;
    return data;
  }
}