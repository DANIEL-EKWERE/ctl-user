import 'dart:convert';

IndustryType industryTypeFromJson(String str) =>
    IndustryType.fromJson(json.decode(str));

String industryTypeToJson(IndustryType data) => json.encode(data.toJson());

class IndustryType {
  bool? status;
  String? message;
  List<IndustryTypeItem>? data;

  IndustryType({this.status, this.message, this.data});

  IndustryType.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <IndustryTypeItem>[];
      json['data'].forEach((v) {
        data!.add(new IndustryTypeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndustryTypeItem {
  int? id;
  String? type;
  String? name;
  String? description;
  String? imageUrl;
  String? sort;
  String? createdAt;

  IndustryTypeItem(
      {this.id,
      this.type,
      this.name,
      this.description,
      this.imageUrl,
      this.sort,
      this.createdAt});

  IndustryTypeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    sort = json['sort'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image_url'] = this.imageUrl;
    data['sort'] = this.sort;
    data['created_at'] = this.createdAt;
    return data;
  }
}
