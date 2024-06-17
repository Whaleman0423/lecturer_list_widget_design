import 'lecturer.dart';
import 'services/data_services.dart';

class DataRepository {
  final DataServices _dataServices = DataServices();

  Future<List<Lecturer>> getLecturers() {
    return _dataServices.fetchLecturers();
  }
}
