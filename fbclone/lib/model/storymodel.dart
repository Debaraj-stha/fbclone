// To parse this JSON data, do
//
//     final stories = storiesFromJson(jsonString);

import 'dart:convert';

List<Stories> storiesFromJson(String str) => List<Stories>.from(json.decode(str).map((x) => Stories.fromJson(x)));

String storiesToJson(List<Stories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stories {
    Stories({
        required this.likes,
        required this.user,
        required this.story,
        required this.views,
        required this.id,
        required this.addedAt
    });

    List<Like> likes;
    List<User> user;
    List<Story> story;
    int views;
    String id;
    DateTime addedAt;

    factory Stories.fromJson(Map<String, dynamic> json) => Stories(
        likes: List<Like>.from(json["likes"].map((x) => Like.fromJson(x))),
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
        story: List<Story>.from(json["story"].map((x) => Story.fromJson(x))),
        views: json["views"],
        id: json["id"],
        addedAt: DateTime.parse(json["addedAt"])
    );

    Map<String, dynamic> toJson() => {
        "likes": List<dynamic>.from(likes.map((x) => x.toJson())),
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
        "story": List<dynamic>.from(story.map((x) => x.toJson())),
        "views": views,
        "id": id,
        "addedAT":addedAt.toIso8601String()
    };
}

class Like {
    Like({
        required this.user,
        required this.id,
    });

    User user;
    String id;

    factory Like.fromJson(Map<String, dynamic> json) => Like(
        user: User.fromJson(json["user"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "id": id,
    };
}

class User {
    User({
        required this.name,
        required this.email,
        required this.profile,
    });

    String name;
    String email;
    String profile;

    factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        profile: json["profile"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "profile": profile,
    };
}

class Story {
    Story({
        required this.type,
        required this.story,
        required this.id,
    });

    String type;
    String story;
    String id;

    factory Story.fromJson(Map<String, dynamic> json) => Story(
        type: json["type"],
        story: json["story"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "story": story,
        "_id": id,
    };
}
