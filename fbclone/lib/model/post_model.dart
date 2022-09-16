// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);

import 'dart:convert';

List<List<Posts>> postsFromJson(String str) => List<List<Posts>>.from(json.decode(str).map((x) => List<Posts>.from(x.map((x) => Posts.fromJson(x)))));

String postsToJson(List<List<Posts>> data) => json.encode(List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))));

class Posts {
    Posts({
        required this.status,
        required this.postAt,
        required this.posts,
        this.likes,
        this.comments,
        required this.user,
        required this.reaction,
        required this.postId

    });

    String status;
    DateTime postAt;
    List<Post> posts;
    List<LikeElement>? likes;
    List<Comment>? comments;
    List<User> user;
    List<String> reaction;
    String postId;
    factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        status: json["status"]==null?" ":json['status'],
        postAt: DateTime.parse(json["postAt"]),
        postId:json['postId'],
        reaction: List<String>.from(json["reaction"].map((x) => x)),
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        likes: List<LikeElement>.from(json["likes"].map((x) => LikeElement.fromJson(x))),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status==null?" ":status,
        "postId": postId,
        "postAt": postAt.toIso8601String(),
        "reaction": List<dynamic>.from(reaction.map((x) => x)),
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "likes": List<dynamic>.from(likes!.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
    };
}

class Comment {
    Comment({
        required this.user,
        required this.commentText,
        required this.commentAt,
        required this.isNotified,
        required this.id,
        this.reply,
        this.commentlikes,
    });

    User user;
    String commentText;
    DateTime commentAt;
    bool isNotified;
    String id;
    List<Reply>? reply;
    List<CommentlikeElement>? commentlikes;

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        user: User.fromJson(json["user"]),
        commentText: json["commentText"],
        commentAt: DateTime.parse(json["commentAt"]),
        isNotified: json["isNotified"],
        id: json["_id"],
        reply: List<Reply>.from(json["reply"].map((x) => Reply.fromJson(x))),
        commentlikes: List<CommentlikeElement>.from(json["commentlikes"].map((x) => CommentlikeElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "commentText": commentText,
        "commentAt": commentAt.toIso8601String(),
        "isNotified": isNotified,
        "_id": id,
        "reply": List<dynamic>.from(reply!.map((x) => x.toJson())),
        "commentlikes": List<dynamic>.from(commentlikes!.map((x) => x.toJson())),
    };
}

class CommentlikeElement {
    CommentlikeElement({
       required this.user,
       required this.isNotified,
       required this.id,
    });

    User user;
    bool isNotified;
    String id;

    factory CommentlikeElement.fromJson(Map<String, dynamic> json) => CommentlikeElement(
        user: User.fromJson(json["user"]),
        isNotified: json["isNotified"],
        id: json["_id"]==null?" ":json['_id'],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "isNotified": isNotified,
        "_id": id == null ? null : id,
    };
}


class Reply {
    Reply({
        required this.user,
        required this.isNotified,
        required this.replyText,
       required  this.replyAt,
        this.replyLikes,
        required this.id,
    });

    User user;
    bool isNotified;
    String replyText;
    DateTime replyAt;
    List<CommentlikeElement>? replyLikes;
    String id;

    factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        user: User.fromJson(json["user"]),
        isNotified: json["isNotified"],
        replyText: json["replyText"],
        replyAt: DateTime.parse(json["replyAt"]),
        replyLikes: List<CommentlikeElement>.from(json["replyLikes"].map((x) => CommentlikeElement.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "isNotified": isNotified,
        "replyText": replyText,
        "replyAt": replyAt.toIso8601String(),
        "replyLikes": List<dynamic>.from(replyLikes!.map((x) => x.toJson())),
        "_id": id,
    };
}

class LikeElement {
    LikeElement({
        required this.user,
        required this.id,
        required this.isNotified,
        required this.types
    });

    User user;
    String id;
    bool isNotified;
  String types;
    factory LikeElement.fromJson(Map<String, dynamic> json) => LikeElement(
        user: User.fromJson(json["user"]),
        id: json["id"] == null ? null : json["id"],
        isNotified: json["isNotified"],
        types:json["types"]
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "id": id == null ? null : id,
        "isNotified": isNotified,
        "types":types
    };
}

class Post {
    Post({
       required this.postType,
       required this.post,
       required this.id,
    });

    String postType;
    String post;
    String id;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        postType: json["postType"],
        post: json["post"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "postType": postType,
        "post": post,
        "_id": id,
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
// To parse this JSON data, do
//
//     final posts = postsFromJson(jsonString);


