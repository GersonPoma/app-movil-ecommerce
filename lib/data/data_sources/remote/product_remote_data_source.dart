import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constant/api.dart';
import '../../../core/error/exceptions.dart';
import '../../models/product/filter_params_model.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(FilterProductParams params);
  Future<ProductResponseModel> fetchProductsFromUrl(String url);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductResponseModel> getProducts(FilterProductParams params) async {
    final uri = Uri.parse('$baseUrl/productos/').replace(
      queryParameters: params.toQueryParams(),
    );

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return productResponseModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }

  /// Implementación del método faltante
  @override
  Future<ProductResponseModel> fetchProductsFromUrl(String url) async {
    final uri = Uri.parse(url);

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return productResponseModelFromJson(response.body);
    } else {
      throw ServerException();
    }
  }
}
