import 'package:flutter/material.dart';
import '../../view_model/lecturers_view_model.dart';
import '../widgets/lecturer_card.dart';

class LecturerListScreen extends StatelessWidget {
  final LecturersViewModel viewModel = LecturersViewModel();

  LecturerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('講師清單'),
      ),
      body: lecturerListBody(),
    );
  }

  Widget lecturerListBody() {
    return FutureBuilder(
      future: viewModel.getLecturers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final lecturers = snapshot.data;
          return ListView.builder(
            itemCount: lecturers?.length ?? 0,
            itemBuilder: (context, index) {
              return LecturerCard(lecturer: lecturers![index]);
            },
          );
        }
      },
    );
  }
}
