class ProfileData {
  Profile? data;

  ProfileData({this.data});

  ProfileData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Profile.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? profilePicture;
  String? username;
  String? fullName;
  Country? country;
  String? bio;
  List<Leagues>? leagues;
  int? likes;
  int? competitions_count;
  String? email;
  String? dob;
  String? role;
  String? createdAt;
  int? receiveNotifications;
  int? private_leagues_count;
  int? private_cups_count;
  int? leagues_count;

  Profile(
      {this.id,
        this.profilePicture,
        this.username,
        this.fullName,
        this.country,
        this.bio,
        this.leagues,
        this.likes,
        this.competitions_count,
        this.email,
        this.dob,
        this.role,
        this.createdAt,
        this.receiveNotifications,
      this.private_leagues_count,
      this.private_cups_count,
      this.leagues_count});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
    fullName = json['full_name'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    bio = json['bio'];
    if (json['leagues'] != null) {
      leagues = <Leagues>[];
      json['leagues'].forEach((v) {
        leagues!.add(new Leagues.fromJson(v));
      });
    }
    likes = json['likes'];
    competitions_count = json['competitions_count'];
    email = json['email'];
    dob = json['dob'];
    role = json['role'];
    createdAt = json['created_at'];
    receiveNotifications = json['receive_notifications'];
    private_leagues_count = json['private_leagues_count'];
    private_cups_count = json['private_cups_count'];
    leagues_count = json['leagues_count'];
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
    if (this.leagues != null) {
      data['leagues'] = this.leagues!.map((v) => v.toJson()).toList();
    }
    data['likes'] = this.likes;
    data['competitions_count'] = this.competitions_count;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['receive_notifications'] = this.receiveNotifications;
    data['private_leagues_count'] = this.private_leagues_count;
    data['private_cups_count'] = this.private_cups_count;
    data['leagues_count'] = this.leagues_count;
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

class Leagues {
  int? id;
  String? name;
  String? type;
  String? logo;

  Leagues({this.id, this.name, this.type, this.logo});

  Leagues.fromJson(Map<String, dynamic> json) {
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