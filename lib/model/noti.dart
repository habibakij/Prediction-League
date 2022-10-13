class NotiData {
  List<Notifi>? data;

  NotiData({this.data});

  NotiData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Notifi>[];
      json['data'].forEach((v) {
        data!.add(new Notifi.fromJson(v));
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

class Notifi {
  String? id;
  Noti? data;
  String? createdAt;

  Notifi({this.id, this.data, this.createdAt});

  Notifi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'] != null ? new Noti.fromJson(json['data']) : null;

    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Noti {
  String? object;
  String? title;
  String? body;
  String? image;
  String? text;
  String? picture;

  Noti(
      {this.object,
        this.title,
        this.body,
        this.image,
        this.text,
        this.picture});

  Noti.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    text = json['text'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['title'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['text'] = this.text;
    data['picture'] = this.picture;
    return data;
  }
}