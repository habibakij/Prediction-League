

class UserProfileData {
  UserProfile? data;

  UserProfileData({this.data});

  UserProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UserProfile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  String? profilePicture;
  String? username;
  String? fullName;
  Country? country;
  String? bio;
  int? likes;
  int? leaguesCount;
  int? privateLeaguesCount;
  int? privateCupsCount;
  String ? created_at;

  UserProfile(
      {this.id,
        this.profilePicture,
        this.username,
        this.fullName,
        this.country,
        this.bio,
        this.likes,
        this.leaguesCount,
        this.privateLeaguesCount,
        this.privateCupsCount,
      this.created_at});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
    fullName = json['full_name'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    bio = json['bio'];
    likes = json['likes'];
    leaguesCount = json['leagues_count'];
    privateLeaguesCount = json['private_leagues_count'];
    privateCupsCount = json['private_cups_count'];
    created_at = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_picture'] = this.profilePicture;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    data['bio'] = this.bio;
    data['likes'] = this.likes;
    data['leagues_count'] = this.leaguesCount;
    data['private_leagues_count'] = this.privateLeaguesCount;
    data['private_cups_count'] = this.privateCupsCount;
    data['created_at'] = this.created_at;
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