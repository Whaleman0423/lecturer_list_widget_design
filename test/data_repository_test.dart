import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_application_1/model/data_repository.dart';
import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/lecturer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DataRepository repository;
  late Database database;

  setUp(() async {
    // sqflite_common_ffi 提供了在 Dart VM 上，
    // 運行的 SQLite 支持，而不是在設備或模擬器上。
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // 初始化內部資料庫
    database = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE lecturers (
            id TEXT PRIMARY KEY,
            uid TEXT,
            name TEXT,
            position TEXT,
            imageUrl TEXT,
            courses TEXT,
            isDeleted INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE courses (
            id TEXT PRIMARY KEY,
            lecturerId TEXT,
            name TEXT,
            description TEXT,
            schedule TEXT,
            isDeleted INTEGER
          )
        ''');
      },
    );

    // 建立 DataRepository 實例，設置資料庫
    repository = DataRepository();
    repository.setDatabase(database);
  });

  tearDown(() async {
    // 測試完後，關閉資料庫
    await database.close();
  });

  test('Test create and fetch lecturers', () async {
    // 創建一個講師資料，並驗證是否可以正常取得
    final lecturer = Lecturer(
      id: '1',
      uid: 'uid_1',
      name: 'John Doe',
      position: Position.Lecturer,
      imageUrl: 'http://example.com/image.jpg',
      courses: [],
      isDeleted: false,
    );

    await repository.createLecturer(lecturer);

    final lecturers = await repository.fetchLecturers();
    expect(lecturers.length, 1);
    expect(lecturers.first.name, 'John Doe');
  });

  test('Test create and fetch courses', () async {
    // 創建一個課程，並驗證是否可以正常取得
    final course = Course(
      id: '1',
      lecturerId: '1',
      name: 'Math 101',
      description: 'Introduction to Mathematics',
      schedule: 'Mon 10:00 - 12:00',
      isDeleted: false,
    );

    await repository.createCourse(course);

    final courses = await repository.fetchCourses();
    expect(courses.length, 1);
    expect(courses.first.name, 'Math 101');
  });

  test('Test fetch courses by lecturer', () async {
    // 根據講師 ID，獲取該講師所開的課程
    final lecturer = Lecturer(
      id: '1',
      uid: 'uid_1',
      name: 'John Doe',
      position: Position.Lecturer,
      imageUrl: 'http://example.com/image.jpg',
      courses: [],
      isDeleted: false,
    );

    final course = Course(
      id: '1',
      lecturerId: '1',
      name: 'Math 101',
      description: 'Introduction to Mathematics',
      schedule: 'Mon 10:00 - 12:00',
      isDeleted: false,
    );

    await repository.createLecturer(lecturer);
    await repository.createCourse(course);

    final courses = await repository.fetchCoursesByLecturer('1');
    expect(courses.length, 1);
    expect(courses.first.name, 'Math 101');
  });

  test('Test update and delete course', () async {
    // 更新一個課程的內容，並驗證刪除功能
    final course = Course(
      id: '1',
      lecturerId: '1',
      name: 'Math 101',
      description: 'Introduction to Mathematics',
      schedule: 'Mon 10:00 - 12:00',
      isDeleted: false,
    );

    await repository.createCourse(course);

    final updatedCourse = Course(
      id: '1',
      lecturerId: '1',
      name: 'Advanced Math 101',
      description: 'Advanced Mathematics',
      schedule: 'Mon 10:00 - 12:00',
      isDeleted: false,
    );

    await repository.updateCourse(updatedCourse);

    final courses = await repository.fetchCourses();
    expect(courses.length, 1);
    expect(courses.first.name, 'Advanced Math 101');

    await repository.deleteCourse('1');
    final remainingCourses = await repository.fetchCourses();
    expect(remainingCourses.length, 0);
  });
}
