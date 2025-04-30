import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:piiicks/data/models/user/user_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/api.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../../domain/usecases/user/sign_up_usecase.dart';
import '../../models/user/authentication_response_model.dart';

abstract class UserRemoteDataSource {
  Future<AuthenticationResponseModel> signIn(SignInParams params);
  Future<AuthenticationResponseModel> signUp(SignUpParams params);

  Future<String> refreshToken(String refreshToken);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthenticationResponseModel> signIn(SignInParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/usuarios/login/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': params.username,
        'password': params.password,
      }),
    );

    if (response.statusCode == 200) {
      return authenticationResponseModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> signUp(SignUpParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/usuarios/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': params.username,
        'password': params.password,
        'email': params.email,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final userJson = jsonDecode(response.body);

      return AuthenticationResponseModel(
        accessToken: '',
        refreshToken: '',
        user: UserModel.fromJson(userJson),
      );
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await client.post(
      Uri.parse('$baseUrl/usuarios/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access'];
    } else {
      throw ServerException();
    }
  }
}
