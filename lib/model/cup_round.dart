class CupRoundData {
  List<CupRound>? data;

  CupRoundData({this.data});

  CupRoundData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CupRound>[];
      json['data'].forEach((v) {
        data!.add(new CupRound.fromJson(v));
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

class CupRound {
  int? id;
  String? name;


  CupRound(
      {this.id,
        this.name,
        });

  CupRound.fromJson(Map<String, dynamic> json) {
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