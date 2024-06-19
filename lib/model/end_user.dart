import 'dart:convert';

import 'package:uuid/uuid.dart';

class EndUser {
  String id;
  String passwordHash;
  String salt;
  String role;
  bool isDeleted;

  EndUser._internal({
    required this.id,
    required this.passwordHash,
    required this.salt,
    required this.role,
    required this.isDeleted,
  });

  factory EndUser({
    String? id,
    required String passwordHash,
    required String salt,
    required String role,
    bool isDeleted = false,
  }) {
    id = id ?? const Uuid().v4();

    return EndUser._internal(
      id: id,
      passwordHash: passwordHash,
      salt: salt,
      role: role,
      isDeleted: isDeleted,
    );
  }

  String toJsonString() => jsonEncode({
        "id": id,
        "passwordHash": passwordHash,
        "salt": salt,
        "role": role,
        "isDeleted": isDeleted,
      });

  factory EndUser.fromJson(Map<String, dynamic> json) {
    return EndUser(
      id: json['id'],
      passwordHash: json['passwordHash'],
      salt: json['salt'],
      role: json['role'],
      isDeleted: json['isDeleted'],
    );
  }
}
