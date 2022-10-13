import 'package:prediction/model/start_prediction.dart';

class RoundData {
  List<Round>? data;

  RoundData({this.data});

  RoundData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Round>[];
      json['data'].forEach((v) {
        data!.add(new Round.fromJson(v));
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

