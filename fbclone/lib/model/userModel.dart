// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
    User({
        required this.id,
        required this.email,
        required this.name,
        required this.phone,
        required this.profile,
        required this.dob,
        required this.joinAt,
        required this.password,
    });

    String id;
    String email;
    String name;
    int phone;
    String profile;
    DateTime dob;
    DateTime joinAt;
    String password;
  

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        profile: json["profile"],
        dob: DateTime.parse(json["dob"]),
        joinAt: DateTime.parse(json["join_at"]),
        password: json["password"],
      
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "phone": phone == null ? null : phone,
        "profile": profile,
        "dob": dob.toIso8601String(),
        "join_at": joinAt.toIso8601String(),
        "password": password,
       
    };
}
