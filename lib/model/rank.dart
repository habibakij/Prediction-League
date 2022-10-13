class RankData {
  List<Rank>? data;

  RankData({this.data});

  RankData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Rank>[];
      json['data'].forEach((v) {
        data!.add(new Rank.fromJson(v));
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

class Rank {
  League? league;
  Season? season;
  World? world;
  World? continent;
  World? country;
  int? points;

  Rank(
      {this.league,
        this.season,
        this.world,
        this.continent,
        this.country,
        this.points});

  Rank.fromJson(Map<String, dynamic> json) {
    league =
    json['league'] != null ? new League.fromJson(json['league']) : null;
    season =
    json['season'] != null ? new Season.fromJson(json['season']) : null;
    world = json['world'] != null ? new World.fromJson(json['world']) : null;
    continent = json['continent'] != null
        ? new World.fromJson(json['continent'])
        : null;
    country =
    json['country'] != null ? new World.fromJson(json['country']) : null;
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.league != null) {
      data['league'] = this.league!.toJson();
    }
    if (this.season != null) {
      data['season'] = this.season!.toJson();
    }
    if (this.world != null) {
      data['world'] = this.world!.toJson();
    }
    if (this.continent != null) {
      data['continent'] = this.continent!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
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

class World {
  int? position;
  int? total;

  World({this.position, this.total});

  World.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['total'] = this.total;
    return data;
  }
}