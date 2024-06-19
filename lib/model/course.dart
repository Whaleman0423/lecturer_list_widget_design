import 'dart:convert';

import 'package:uuid/uuid.dart';

class Course {
  String id;
  String lecturerId;
  String name;
  String description;
  String schedule;
  bool isDeleted;

  Course._internal({
    required this.id,
    required this.lecturerId,
    required this.name,
    required this.description,
    required this.schedule,
    required this.isDeleted,
  });

  factory Course({
    String? id,
    required String lecturerId,
    required String name,
    required String description,
    required String schedule,
    bool isDeleted = false,
  }) {
    id = id ?? const Uuid().v4();

    return Course._internal(
      id: id,
      lecturerId: lecturerId,
      name: name,
      description: description,
      schedule: schedule,
      isDeleted: isDeleted,
    );
  }

  String toJsonString() => jsonEncode({
        "id": id,
        "lecturerId": lecturerId,
        "name": name,
        "description": description,
        "schedule": schedule,
        "isDeleted": isDeleted ? 1 : 0,
      });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      lecturerId: json['lecturerId'],
      name: json['name'],
      description: json['description'],
      schedule: json['schedule'],
      isDeleted: json['isDeleted'] == 1,
    );
  }
}
