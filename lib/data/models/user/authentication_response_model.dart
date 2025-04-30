import 'dart:convert';
import 'user_model.dart';

AuthenticationResponseModel authenticationResponseModelFromJson(String str) =>
    AuthenticationResponseModel.fromJson(json.decode(str));

String authenticationResponseModelToJson(AuthenticationResponseModel data) =>
    json.encode(data.toJson());

class AuthenticationResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthenticationResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponseModel(
        accessToken: json["access"],
        refreshToken: json["refresh"],
        user: UserModel(
          id: json["user_id"].toString(),
          username: json["username"],
          email: '',
          rol: json["rol"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "access": accessToken,
        "refresh": refreshToken,
        "user": user.toJson(),
      };
}
