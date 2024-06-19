import 'dart:convert';

import 'package:uuid/uuid.dart';

class CourseRegistration {
  String id;
  String studentId;
  String courseId;

  CourseRegistration._internal({
    required this.id,
    required this.studentId,
    required this.courseId,
  });

  factory CourseRegistration({
    String? id,
    required String studentId,
    required String courseId,
  }) {
    id = id ?? const Uuid().v4();

    return CourseRegistration._internal(
      id: id,
      studentId: studentId,
      courseId: courseId,
    );
  }

  String toJsonString() => jsonEncode({
        "id": id,
        "studentId": studentId,
        "courseId": courseId,
      });

  factory CourseRegistration.fromJson(Map<String, dynamic> json) {
    return CourseRegistration(
      id: json['id'],
      studentId: json['studentId'],
      courseId: json['courseId'],
    );
  }
}
