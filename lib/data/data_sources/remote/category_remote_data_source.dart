import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../core/constant/api.dart';

import '../../../core/error/failures.dart';
import '../../models/category/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final http.Client client;
  CategoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CategoryModel>> getCategories() =>
      _getCategoryFromUrl('$baseUrl/categorias/');

  Future<List<CategoryModel>> _getCategoryFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return categoryModelListFromRemoteJson(jsonEncode(decoded['results']));
    } else {
      throw ServerFailure();
    }
  }
}
