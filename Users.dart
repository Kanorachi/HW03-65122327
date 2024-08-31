// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Users {
    int? id;
    String? fullname;
    String? email;
    String? password;
    String? gender;

    Users({
        this.id,
        this.fullname,
        this.email,
        this.password,
        this.gender,
    });
  Users.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()); // แปลง id เป็น int
    fullname = json['fullname'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
  }
    Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "gender": gender,
    };
}
