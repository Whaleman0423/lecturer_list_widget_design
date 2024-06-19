import 'package:flutter/material.dart';
import '../model/lecturer.dart';
import '../model/data_repository.dart';

class LecturersViewModel extends ChangeNotifier {
  final DataRepository _repository = DataRepository();
  List<Lecturer> _lecturers = [];

  List<Lecturer> get lecturers => _lecturers;

  Future<void> fetchLecturers() async {
    try {
      _lecturers = await _repository.fetchLecturers();
      notifyListeners();
    } catch (e) {
      // 可以在这里处理错误，例如记录日志或显示错误信息
      print('Failed to fetch lecturers: $e');
    }
  }
}
