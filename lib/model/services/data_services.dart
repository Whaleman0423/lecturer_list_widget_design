import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../course.dart';
import '../lecturer.dart';

class DataServices {
  Future<List<Lecturer>> fetchLecturers() async {
    final response =
        await http.get(Uri.parse('https://randomuser.me/api/?results=10'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      final Random random = Random();

      List<Lecturer> lecturers = data.map((json) {
        final position =
            Position.values[random.nextInt(Position.values.length)];
        return Lecturer(
          name: "${json['name']['first']} ${json['name']['last']}",
          position: position,
          imageUrl: json['picture']['large'],
          courses: [
            Course(
              name: '基礎程式設計',
              description: '基礎程式設計課程介紹',
              schedule: '每週二, 10:00~12:00',
            ),
            Course(
              name: '人工智慧總整與實作',
              description: '人工智慧課程介紹',
              schedule: '每週四, 14:00~16:00',
            ),
            Course(
              name: '訊號與系統',
              description: '訊號與系統課程介紹',
              schedule: '每週五, 10:00~12:00',
            ),
          ],
        );
      }).toList();
      return lecturers;
    } else {
      throw Exception('Failed to load lecturers');
    }
  }
}
