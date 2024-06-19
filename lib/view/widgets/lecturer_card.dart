import 'package:flutter/material.dart';
import '../../model/lecturer.dart';
import '../../model/course.dart'; // 导入 Course 模型
import '../screens/course_detail_screen.dart';
import '../../model/data_repository.dart'; // 导入 DataRepository

class LecturerCard extends StatelessWidget {
  final Lecturer lecturer;

  const LecturerCard({super.key, required this.lecturer});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: cardShape,
      color: Colors.white,
      child: lecturerCardExpansionTile(context),
    );
  }

  Widget lecturerCardExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: lecturerAvatar(),
      title: lecturerPositionText(),
      subtitle: Text(lecturer.name),
      trailing: const Icon(Icons.add),
      children: [
        divider,
        FutureBuilder<List<Course>>(
          future: fetchCoursesList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final courses = snapshot.data!;
              return coursesList(context, courses);
            }
          },
        ),
      ],
    );
  }

  Future<List<Course>> fetchCoursesList() async {
    final repository = DataRepository();
    return await repository.fetchCoursesByLecturer(lecturer.id);
  }

  Widget lecturerAvatar() {
    return CircleAvatar(
      backgroundImage: NetworkImage(lecturer.imageUrl),
    );
  }

  Widget coursesList(BuildContext context, List<Course> courses) {
    return Column(
      children: courses.map((course) {
        return ListTile(
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(course.name),
          subtitle: Text(course.schedule),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(course: course),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget lecturerPositionText() {
    return Text(
      lecturer.position.displayName,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}

RoundedRectangleBorder cardShape = RoundedRectangleBorder(
  side: const BorderSide(color: Colors.black, width: 1),
  borderRadius: BorderRadius.circular(8),
);

Widget divider = const Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  child: Divider(),
);
