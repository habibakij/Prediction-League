
class PrivateLeagueDetailData {
  List<PrivateLeagueDetail>? data;
  Meta? meta;

  PrivateLeagueDetailData({this.data, this.meta});

  PrivateLeagueDetailData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PrivateLeagueDetail>[];
      json['data'].forEach((v) {
        data!.add(new PrivateLeagueDetail.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class PrivateLeagueDetail {
  int? position;
  int? mostRecentPosition;
  User? user;
  int? pointsFromLastRound;
  int? points;

  PrivateLeagueDetail(
      {this.position,
        this.mostRecentPosition,
        this.user,
        this.pointsFromLastRound,
        this.points});

  PrivateLeagueDetail.fromJson(Map<String, dynamic> json) {
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


class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}


