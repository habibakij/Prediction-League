class ChatData {
  List<Chat>? data;

  ChatData({this.data});

  ChatData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Chat>[];
      json['data'].forEach((v) {
        data!.add(new Chat.fromJson(v));
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

class Chat {
  int? id;
  String? comment;
  String? createdAt;
  User? user;
  Chat1? chat;
  String? message;
  int? competitionId;
  String? competitionTitle;
  int? competitors;

  Chat(
      {this.id,
        this.comment,
        this.createdAt,
        this.user,
        this.chat,
        this.message,
        this.competitionId,
        this.competitionTitle,
        this.competitors});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if(json.containsKey("chat")){
      chat = json['chat'] != null ? new Chat1.fromJson(json['chat']) : null;
    }
    message = json['message'];
    competitionId = json['competition_id'];
    competitionTitle = json['competition_title'];
    competitors = json['competitors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.chat != null) {
      data['chat'] = this.chat!.toJson();
    }
    data['message'] = this.message;
    data['competition_id'] = this.competitionId;
    data['competition_title'] = this.competitionTitle;
    data['competitors'] = this.competitors;
    return data;
  }
}

class User {
  int? id;
  String? profilePicture;
  String? username;

  User({this.id, this.profilePicture, this.username});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profilePicture = json['profile_picture'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_picture'] = this.profilePicture;
    data['username'] = this.username;
    return data;
  }
}
class Chat1 {
  int? id;
  String? comment;
  String? createdAt;
  User? user;
  String? message;
  int? competitionId;
  String? competitionTitle;
  int? competitors;

  Chat1(
      {this.id,
        this.comment,
        this.createdAt,
        this.user,
        this.message,
        this.competitionId,
        this.competitionTitle,
        this.competitors});

  Chat1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
    competitionId = json['competition_id'];
    competitionTitle = json['competition_title'];
    competitors = json['competitors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    data['competition_id'] = this.competitionId;
    data['competition_title'] = this.competitionTitle;
    data['competitors'] = this.competitors;
    return data;
  }
}