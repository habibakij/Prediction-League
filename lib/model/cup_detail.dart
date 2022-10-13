import 'package:prediction/model/private_league.dart';

class CupDetailData {
  CupDetail? data;

  CupDetailData({this.data});

  CupDetailData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CupDetail.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CupDetail {
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
  int? participants;
  User? user;
  int? competitorsCount;
  List<Competitors>? competitors;
  List<Rounds>? rounds;

  CupDetail(
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
        this.participants,
        this.user,
        this.competitorsCount,
        this.competitors,
        this.rounds});

  CupDetail.fromJson(Map<String, dynamic> json) {
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
    participants = json['participants'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    competitorsCount = json['competitors_count'];
    if (json['competitors'] != null) {
      competitors = <Competitors>[];
      json['competitors'].forEach((v) {
        competitors!.add(new Competitors.fromJson(v));
      });
    }
    if (json['rounds'] != null) {
      rounds = <Rounds>[];
      json['rounds'].forEach((v) {
        rounds!.add(new Rounds.fromJson(v));
      });
    }
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
    data['participants'] = this.participants;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['competitors_count'] = this.competitorsCount;
    if (this.competitors != null) {
      data['competitors'] = this.competitors!.map((v) => v.toJson()).toList();
    }
    if (this.rounds != null) {
      data['rounds'] = this.rounds!.map((v) => v.toJson()).toList();
    }
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


class Competitors {
  int? id;
  String? profilePicture;
  String? username;
  int? points;
  int? roundPoints;

  Competitors(
      {this.id,
        this.profilePicture,
        this.username,
        this.points,
        this.roundPoints});

  Competitors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
    points = json['points'];
    roundPoints = json['round_points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_picture'] = this.profilePicture;
    data['username'] = this.username;
    data['points'] = this.points;
    data['round_points'] = this.roundPoints;
    return data;
  }
}

class Rounds {
  int? id;
  String? name;
  List<Fixtures>? fixtures;

  Rounds({this.id, this.name, this.fixtures});

  Rounds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['fixtures'] != null) {
      fixtures = <Fixtures>[];
      json['fixtures'].forEach((v) {
        fixtures!.add(new Fixtures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.fixtures != null) {
      data['fixtures'] = this.fixtures!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fixtures {
  int? id;
  List<Users>? users;

  Fixtures({this.id, this.users});

  Fixtures.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? profilePicture;
  String? username;
  String? subscribed_at;
  int? points;

  Users({this.id, this.profilePicture, this.username, this.points,this.subscribed_at});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
    subscribed_at = json['subscribed_at'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_picture'] = this.profilePicture;
    data['username'] = this.username;
    data['subscribed_at'] = this.subscribed_at;
    data['points'] = this.points;
    return data;
  }
}