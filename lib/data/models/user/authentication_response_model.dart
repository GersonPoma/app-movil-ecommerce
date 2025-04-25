class AuthenticationResponseModel {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String username;
  final String rol;

  const AuthenticationResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.rol,
  });

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponseModel(
        accessToken: json["access"],
        refreshToken: json["refresh"],
        userId: json["user_id"].toString(),
        username: json["username"],
        rol: json["rol"],
      );

  Map<String, dynamic> toJson() => {
        "access": accessToken,
        "refresh": refreshToken,
        "user_id": userId,
        "username": username,
        "rol": rol,
      };
}
