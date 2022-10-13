class PageData {
  Page? data;

  PageData({this.data});

  PageData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Page.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Page {
  int? id;
  String? type;
  String? icon;
  String? universalTitle;
  String? title;
  String? content;
  String? picture;

  Page(
      {this.id,
        this.type,
        this.icon,
        this.universalTitle,
        this.title,
        this.content,
        this.picture});

  Page.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    icon = json['icon'];
    universalTitle = json['universal_title'];
    title = json['title'];
    content = json['content'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['icon'] = this.icon;
    data['universal_title'] = this.universalTitle;
    data['title'] = this.title;
    data['content'] = this.content;
    data['picture'] = this.picture;
    return data;
  }
}