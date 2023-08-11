import 'dart:convert';

List<FakeTitleBodyData> withdrawalListViewFromJson(String str) => List<FakeTitleBodyData>.from(json.decode(str).map((x) => FakeTitleBodyData.fromJson(x)));

String withdrawalListViewToJson(List<FakeTitleBodyData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FakeTitleBodyData {
  final int userId;
  final int id;
  final String title;
  final String body;

  FakeTitleBodyData({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory FakeTitleBodyData.fromJson(Map<String, dynamic> json) => FakeTitleBodyData(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
