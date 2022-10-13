class CountryData {
  List<Country>? data;

  CountryData({this.data});

  CountryData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Country>[];
      json['data'].forEach((v) {
        data!.add(new Country.fromJson(v));
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

class Country {
  int? id;
  String? name;
  String? code;
  String? continent;
  String? continentCode;
  String? alpha3;

  Country(
      {this.id,
        this.name,
        this.code,
        this.continent,
        this.continentCode,
        this.alpha3});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    continent = json['continent'];
    continentCode = json['continent_code'];
    alpha3 = json['alpha_3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['continent'] = this.continent;
    data['continent_code'] = this.continentCode;
    data['alpha_3'] = this.alpha3;
    return data;
  }
}