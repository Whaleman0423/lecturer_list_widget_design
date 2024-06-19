import 'dart:convert';
import 'package:uuid/uuid.dart';

enum Position {
  Demonstrator,
  Lecturer,
  SeniorLecturer,
  Professor,
}

extension PositionExtension on Position {
  String get displayName {
    switch (this) {
      case Position.Demonstrator:
        return 'Demonstrator';
      case Position.Lecturer:
        return 'Lecturer';
      case Position.SeniorLecturer:
        return 'Senior Lecturer';
      case Position.Professor:
        return 'Professor';
      default:
        return '';
    }
  }
}

class Lecturer {
  String id;
  String uid;
  String name;
  Position position;
  String imageUrl;
  List<String> courses;
  bool isDeleted;

  Lecturer._internal({
    required this.id,
    required this.uid,
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.courses,
    required this.isDeleted,
  });

  factory Lecturer({
    String? id,
    required String uid,
    required String name,
    required Position position,
    required String imageUrl,
    List<String> courses = const [],
    bool isDeleted = false,
  }) {
    id = id ?? const Uuid().v4();

    return Lecturer._internal(
      id: id,
      uid: uid,
      name: name,
      position: position,
      imageUrl: imageUrl,
      courses: courses,
      isDeleted: isDeleted,
    );
  }

  String toJsonString() => jsonEncode({
        "id": id,
        "uid": uid,
        "name": name,
        "position": position.displayName,
        "imageUrl": imageUrl,
        "courses": jsonEncode(courses),
        "isDeleted": isDeleted ? 1 : 0,
      });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      position: _positionFromString(json['position']),
      imageUrl: json['imageUrl'],
      courses: List<String>.from(jsonDecode(json['courses'])),
      isDeleted: json['isDeleted'] == 1,
    );
  }

  static Position _positionFromString(String position) {
    switch (position) {
      case 'Demonstrator':
        return Position.Demonstrator;
      case 'Lecturer':
        return Position.Lecturer;
      case 'Senior Lecturer':
        return Position.SeniorLecturer;
      case 'Professor':
        return Position.Professor;
      default:
        throw ArgumentError('Invalid position value');
    }
  }
}
