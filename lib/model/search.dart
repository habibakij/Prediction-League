import 'package:prediction/model/private_league.dart';
class SearchData {
  List<Search>? data;

  SearchData({this.data});

  SearchData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Search>[];
      json['data'].forEach((v) {
        data!.add(new Search.fromJson(v));
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

class Search {
  int? id;
  String? code;
  League? league;
  Season? season;
  CurrentRound? currentRound;
  String? category;
  String? title;
  String? description;
  String? joinedBy;
  String? playFor;
  String? contact;
  String? type;
  CurrentRound? startingRound;
  String? status;
  bool? out;
  int? participants;
  User? user;
  int? competitorsCount;
  User? winner;
  int? rank;

  Search(
      {this.id,
        this.code,
        this.league,
        this.season,
        this.currentRound,
        this.category,
        this.title,
        this.description,
        this.joinedBy,
        this.playFor,
        this.contact,
        this.type,
        this.startingRound,
        this.status,
        this.out,
        this.participants,
        this.user,
        this.competitorsCount,
        this.winner,
        this.rank});

  Search.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    league =
    json['league'] != null ? new League.fromJson(json['league']) : null;
    season =
    json['season'] != null ? new Season.fromJson(json['season']) : null;
    currentRound = json['current_round'] != null
        ? new CurrentRound.fromJson(json['current_round'])
        : null;
    category = json['category'];
    title = json['title'];
    description = json['description'];
    joinedBy = json['joined_by'];
    playFor = json['play_for'];
    contact = json['contact'];
    type = json['type'];
    startingRound = json['starting_round'] != null
        ? new CurrentRound.fromJson(json['starting_round'])
        : null;
    status = json['status'];
    out = json['out'];
    participants = json['participants'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    competitorsCount = json['competitors_count'];
    winner = json['winner'] != null ? new User.fromJson(json['winner']) : null;
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.currentRound != null) {
      data['current_round'] = this.currentRound!.toJson();
    }
    data['category'] = this.category;
    data['title'] = this.title;
    data['description'] = this.description;
    data['joined_by'] = this.joinedBy;
    data['play_for'] = this.playFor;
    data['contact'] = this.contact;
    data['type'] = this.type;
    if (this.startingRound != null) {
      data['starting_round'] = this.startingRound!.toJson();
    }
    data['status'] = this.status;
    data['out'] = this.out;
    data['participants'] = this.participants;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['competitors_count'] = this.competitorsCount;
    if (this.winner != null) {
      data['winner'] = this.winner!.toJson();
    }
    data['rank'] = this.rank;
    return data;
  }
}

class League {
  int? id;
  String? name;
  String? type;
  String? logo;

  League({this.id, this.name, this.type, this.logo});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['logo'] = this.logo;
    return data;
  }
}

class Season {
  int? id;
  String? year;

  Season({this.id, this.year});

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['year'] = this.year;
    return data;
  }
}

class CurrentRound {
  int? id;
  String? name;
  String? startedAt;
  String? endedAt;
  int? points;

  CurrentRound({this.id, this.name, this.startedAt, this.endedAt, this.points});

  CurrentRound.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startedAt = json['started_at'];
    endedAt = json['ended_at'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['started_at'] = this.startedAt;
    data['ended_at'] = this.endedAt;
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






