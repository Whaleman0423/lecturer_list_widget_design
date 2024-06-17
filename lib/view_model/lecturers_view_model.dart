import '../model/lecturer.dart';
import '../model/data_repository.dart';

class LecturersViewModel {
  final DataRepository _repository = DataRepository();

  Future<List<Lecturer>> getLecturers() {
    return _repository.getLecturers();
  }
}
