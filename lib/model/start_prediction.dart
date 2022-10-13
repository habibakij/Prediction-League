class StartPredictionData {
  List<StartPrediction>? data;
  Meta? meta;

  StartPredictionData({this.data, this.meta});

  StartPredictionData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StartPrediction>[];
      json['data'].forEach((v) {
        data!.add(new StartPrediction.fromJson(v));
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

class StartPrediction {
  int? id;
  String? timezone;
  String? timestamp;
  String? longStatus;
  String? shortStatus;
  String? leagueRound;
  League? league;
  Season? season;
  Round? round;
  List<Teams>? teams;
  Comparison? comparison;
  Prediction? prediction;
  StartPrediction(
      {this.id,
        this.timezone,
        this.timestamp,
        this.longStatus,
        this.shortStatus,
        this.leagueRound,
        this.league,
        this.season,
        this.round,
        this.teams,
        this.comparison,
        this.prediction});

  StartPrediction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timezone = json['timezone'];
    timestamp = json['timestamp'];
    longStatus = json['long_status'];
    shortStatus = json['short_status'];
    leagueRound = json['league_round'];
    league =
    json['league'] != null ? new League.fromJson(json['league']) : null;
    season =
    json['season'] != null ? new Season.fromJson(json['season']) : null;
    round = json['round'] != null ? new Round.fromJson(json['round']) : null;
    if (json['teams'] != null) {
      teams = <Teams>[];
      json['teams'].forEach((v) {
        teams!.add(new Teams.fromJson(v));
      });
    }
    comparison = json['comparison'] != null
        ? new Comparison.fromJson(json['comparison'])
        : null;
    prediction = json.containsKey("prediction")&&json['prediction'] != null
        ? new Prediction.fromJson(json['prediction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timezone'] = this.timezone;
    data['timestamp'] = this.timestamp;
    data['long_status'] = this.longStatus;
    data['short_status'] = this.shortStatus;
    data['league_round'] = this.leagueRound;
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.round != null) {
      data['round'] = this.round!.toJson();
    }
    if (this.teams != null) {
      data['teams'] = this.teams!.map((v) => v.toJson()).toList();
    }
    if (this.comparison != null) {
      data['comparison'] = this.comparison!.toJson();
    }
    if (this.prediction != null) {
      data['prediction'] = this.prediction!.toJson();
    }
    return data;
  }
}
class Prediction {
  int? homeTeamGoals;
  int? awayTeamGoals;
  int? multiplyByTwo;
  int? points;

  Prediction(
      {this.homeTeamGoals,
        this.awayTeamGoals,
        this.multiplyByTwo,
        this.points});

  Prediction.fromJson(Map<String, dynamic> json) {
    homeTeamGoals = json['home_team_goals'];
    awayTeamGoals = json['away_team_goals'];
    multiplyByTwo = json['multiply_by_two'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_team_goals'] = this.homeTeamGoals;
    data['away_team_goals'] = this.awayTeamGoals;
    data['multiply_by_two'] = this.multiplyByTwo;
    data['points'] = this.points;
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

class Round {
  int? id;
  String? name;
  String? startedAt;
  String? endedAt;
  bool? current_round=false;
  bool enabled=false;
  int? points;


  Round({this.id, this.name, this.startedAt, this.endedAt,this.current_round=false,this.enabled=false,this.points});

  Round.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if(json.containsKey("started_at")){
      startedAt = json['started_at'];
    }
    if(json.containsKey("ended_at")){
      endedAt = json['ended_at'];
    }
    if(json.containsKey("current_round")){
      current_round = json['current_round'];
    }
    if(json.containsKey("enabled")){
      enabled = json['enabled'];
    }
    if(json.containsKey("points")){
      points = json['points'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['started_at'] = this.startedAt;
    data['ended_at'] = this.endedAt;
    data['current_round'] = this.current_round;
    data['enabled'] = this.enabled;
    data['points'] = this.points;
    return data;
  }
}

class Teams {
  int? id;
  String? name;
  String? code;
  String? logo;
  String? ground;
  int? goals;

  Teams({this.id, this.name, this.code, this.logo, this.ground,this.goals});

  Teams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    logo = json['logo'];
    ground = json['ground'];
    if(json.containsKey("goals")){
      goals = json['goals'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['logo'] = this.logo;
    data['ground'] = this.ground;
    data['goals'] = this.goals;
    return data;
  }
}

class Comparison {
  Win? win;

  Comparison({this.win});

  Comparison.fromJson(Map<String, dynamic> json) {
    win = json['win'] != null ? new Win.fromJson(json['win']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.win != null) {
      data['win'] = this.win!.toJson();
    }
    return data;
  }
}

class Win {
  num? home;
  num? away;

  Win({this.home, this.away});

  Win.fromJson(Map<String, dynamic> json) {
    home = json['home'];
    away = json['away'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home'] = this.home;
    data['away'] = this.away;
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
