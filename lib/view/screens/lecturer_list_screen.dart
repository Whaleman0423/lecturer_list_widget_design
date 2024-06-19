import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_model/lecturers_view_model.dart';
import '../widgets/lecturer_card.dart';

class LecturerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LecturersViewModel()..fetchLecturers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('讲师清单'),
        ),
        body: Consumer<LecturersViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.lecturers.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: viewModel.lecturers.length,
                itemBuilder: (context, index) {
                  return LecturerCard(lecturer: viewModel.lecturers[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
