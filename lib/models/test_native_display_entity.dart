// To parse this JSON data, do
//
//     final testNativeDisplayEntity = testNativeDisplayEntityFromJson(jsonString);

import 'dart:convert';

List<TestNativeDisplayEntity> testNativeDisplayEntityFromJson(String str) =>
    List<TestNativeDisplayEntity>.from(
        json.decode(str).map((x) => TestNativeDisplayEntity.fromJson(x)));

String testNativeDisplayEntityToJson(List<TestNativeDisplayEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestNativeDisplayEntity {
  String? wzrkId;
  String? bg;
  int? ti;
  String? wzrkPivot;
  String? type;
  List<dynamic>? customKvData;
  List<Content>? content;

  TestNativeDisplayEntity({
    this.wzrkId,
    this.bg,
    this.ti,
    this.wzrkPivot,
    this.type,
    this.customKvData,
    this.content,
  });

  factory TestNativeDisplayEntity.fromJson(Map<String, dynamic> json) =>
      TestNativeDisplayEntity(
        wzrkId: json["wzrk_id"],
        bg: json["bg"],
        ti: json["ti"],
        wzrkPivot: json["wzrk_pivot"],
        type: json["type"],
        customKvData: List<dynamic>.from(json["customKVData"].map((x) => x)),
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wzrk_id": wzrkId,
        "bg": bg,
        "ti": ti,
        "wzrk_pivot": wzrkPivot,
        "type": type,
        "customKVData": List<dynamic>.from(customKvData!.map((x) => x)),
        "content": List<dynamic>.from(content!.map((x) => x.toJson())),
      };
}

class Content {
  bool? isIconSourceRecommended;
  Message? recommendedText;
  Icon? icon;
  Action? action;
  Message? recommendedIconText;
  Media? media;
  Message? message;
  Message? title;
  bool? isMediaSourceRecommended;
  int? key;

  Content({
    this.isIconSourceRecommended,
    this.recommendedText,
    this.icon,
    this.action,
    this.recommendedIconText,
    this.media,
    this.message,
    this.title,
    this.isMediaSourceRecommended,
    this.key,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        isIconSourceRecommended: json["isIconSourceRecommended"],
        recommendedText: Message.fromJson(json["recommendedText"]),
        icon: Icon.fromJson(json["icon"]),
        action: Action.fromJson(json["action"]),
        recommendedIconText: Message.fromJson(json["recommendedIconText"]),
        media: Media.fromJson(json["media"]),
        message: Message.fromJson(json["message"]),
        title: Message.fromJson(json["title"]),
        isMediaSourceRecommended: json["isMediaSourceRecommended"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "isIconSourceRecommended": isIconSourceRecommended,
        "recommendedText": recommendedText!.toJson(),
        "icon": icon!.toJson(),
        "action": action!.toJson(),
        "recommendedIconText": recommendedIconText!.toJson(),
        "media": media!.toJson(),
        "message": message!.toJson(),
        "title": title!.toJson(),
        "isMediaSourceRecommended": isMediaSourceRecommended,
        "key": key,
      };
}

class Action {
  bool? hasUrl;
  Url? url;

  Action({
    this.hasUrl,
    this.url,
  });

  factory Action.fromJson(Map<String, dynamic> json) => Action(
        hasUrl: json["hasUrl"],
        url: Url.fromJson(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "hasUrl": hasUrl,
        "url": url!.toJson(),
      };
}

class Url {
  Message? android;
  Message? ios;

  Url({
    this.android,
    this.ios,
  });

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        android: Message.fromJson(json["android"]),
        ios: Message.fromJson(json["ios"]),
      );

  Map<String, dynamic> toJson() => {
        "android": android!.toJson(),
        "ios": ios!.toJson(),
      };
}

class Message {
  String? og;
  String? text;
  String? replacements;
  String? color;

  Message({
    this.og,
    this.text,
    this.replacements,
    this.color,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        og: json["og"],
        text: json["text"],
        replacements: json["replacements"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "og": og,
        "text": text,
        "replacements": replacements,
        "color": color,
      };
}

class Icon {
  Icon();

  factory Icon.fromJson(Map<String, dynamic> json) => Icon();

  Map<String, dynamic> toJson() => {};
}

class Media {
  String? filename;
  String? contentType;
  bool? processing;
  String? poster;
  String? url;
  String? key;

  Media({
    this.filename,
    this.contentType,
    this.processing,
    this.poster,
    this.url,
    this.key,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        filename: json["filename"],
        contentType: json["content_type"],
        processing: json["processing"],
        poster: json["poster"],
        url: json["url"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "filename": filename,
        "content_type": contentType,
        "processing": processing,
        "poster": poster,
        "url": url,
        "key": key,
      };
}
