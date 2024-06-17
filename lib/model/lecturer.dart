import 'course.dart';

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
  final String name;
  final Position position;
  final String imageUrl;
  final List<Course> courses;

  Lecturer({
    required this.name,
    required this.position,
    required this.imageUrl,
    required this.courses,
  });
}
