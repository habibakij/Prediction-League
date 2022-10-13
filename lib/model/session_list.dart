import 'package:prediction/model/private_league.dart';

class SessionList {
  List<Season>? data;

  SessionList({this.data});

  SessionList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Season>[];
      json['data'].forEach((v) {
        data!.add(new Season.fromJson(v));
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
