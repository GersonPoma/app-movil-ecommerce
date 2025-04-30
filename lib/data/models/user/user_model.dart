import 'dart:convert';
import '../../../domain/entities/user/user.dart';

// Métodos para manejar JSON
UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));
String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends User {
  const UserModel({
    required String id,
    required String username,
    required String email,
    required String rol,
  }) : super(
          id: id,
          username: username,
          email: email,
          rol: rol,
        );

  // Factory adaptado a lo que devuelve tu backend Django
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"].toString(),
        username: json["username"],
        email: json["email"] ?? '',
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "rol": rol,
      };
}
