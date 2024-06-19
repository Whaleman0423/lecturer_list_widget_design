import 'dart:convert';

import 'package:uuid/uuid.dart';

class Student {
  String id;
  String uid;
  String name;
  String major;
  bool isDeleted;

  Student._internal({
    required this.id,
    required this.uid,
    required this.name,
    required this.major,
    required this.isDeleted,
  });

  factory Student({
    String? id,
    required String uid,
    required String name,
    required String major,
    bool isDeleted = false,
  }) {
    id = id ?? const Uuid().v4();

    return Student._internal(
      id: id,
      uid: uid,
      name: name,
      major: major,
      isDeleted: isDeleted,
    );
  }

  String toJsonString() => jsonEncode({
        "id": id,
        "uid": uid,
        "name": name,
        "major": major,
        "isDeleted": isDeleted,
      });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      major: json['major'],
      isDeleted: json['isDeleted'],
    );
  }
}
