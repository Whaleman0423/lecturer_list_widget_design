import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'course.dart';
import 'lecturer.dart';

class DataRepository {
  // Singleton Pattern
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;

  // 資料庫物件
  static Database? _database;

  // 內部建構函數
  DataRepository._internal();

  // 外部獲取資料庫物件
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // 資料庫物件 初始化
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 建立教師表
        db.execute('''
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
        // 建立課程表
        db.execute('''
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
  }

  // 取得課程列表 (Read)
  Future<List<Course>> fetchCourses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('courses', where: 'isDeleted = ?', whereArgs: [0]);

    return List.generate(maps.length, (i) {
      return Course.fromJson(maps[i]);
    });
  }

  // 取得講師列表 (Read)
  Future<List<Lecturer>> fetchLecturers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('lecturers', where: 'isDeleted = ?', whereArgs: [0]);

    return List.generate(maps.length, (i) {
      return Lecturer.fromJson(maps[i]);
    });
  }

  // 取得某講師所開的課程 (Read)
  Future<List<Course>> fetchCoursesByLecturer(String lecturerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('courses',
        where: 'lecturerId = ? AND isDeleted = ?', whereArgs: [lecturerId, 0]);

    return List.generate(maps.length, (i) {
      return Course.fromJson(maps[i]);
    });
  }

  // 建立新講師 (Create)
  Future<void> createLecturer(Lecturer lecturer) async {
    final db = await database;
    await db.insert('lecturers', jsonDecode(lecturer.toJsonString()),
        // 若有相同 id 則取代並更新
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 建立新課程 (Create)
  Future<void> createCourse(Course course) async {
    final db = await database;
    await db.insert('courses', jsonDecode(course.toJsonString()),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // 更新課程 (Update)
  Future<void> updateCourse(Course course) async {
    final db = await database;
    await db.update('courses', jsonDecode(course.toJsonString()),
        where: 'id = ?', whereArgs: [course.id]);
  }

  // 刪除課程 (Delete)
  Future<void> deleteCourse(String courseId) async {
    final db = await database;
    await db.update('courses', {'isDeleted': 1},
        where: 'id = ?', whereArgs: [courseId]);
  }
}
