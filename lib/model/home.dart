class HomeData {
  List<Home>? data;

  HomeData({this.data});

  HomeData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Home>[];
      json['data'].forEach((v) {
        data!.add(new Home.fromJson(v));
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

class Home {
  int? id;
  String? name;
  String? type;
  String? logo;
  CRound? currentRound;
  bool? isSubscribed;

  Home({this.id, this.name, this.type, this.logo,this.currentRound,
    this.isSubscribed});

  Home.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    logo = json['logo'];
    currentRound = json['current_round'] != null
        ? CRound.fromJson(json['current_round'])
        : null;
    if(json.containsKey("is_subscribed")){
      isSubscribed = json['is_subscribed'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['logo'] = this.logo;
    if (this.currentRound != null) {
      data['current_round'] = this.currentRound!.toJson();
    }
    data['is_subscribed'] = this.isSubscribed;
    return data;
  }
}
class CRound {
  int? id;
  String? name;

  CRound({this.id, this.name});

  CRound.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}