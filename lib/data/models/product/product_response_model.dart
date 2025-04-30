import '../../../domain/entities/product/product.dart';
import '../../../domain/entities/product/product_response.dart';
import 'product_model.dart';
import 'dart:convert';

ProductResponseModel productResponseModelFromJson(String str) =>
    ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) =>
    json.encode(data.toJson());

class ProductResponseModel extends ProductResponse {
  ProductResponseModel({
    required List<ProductEntity> productos,
    required int total,
    String? siguientePaginaUrl,
    String? paginaAnteriorUrl,
  }) : super(
          productos: productos,
          total: total,
          siguientePaginaUrl: siguientePaginaUrl,
          paginaAnteriorUrl: paginaAnteriorUrl,
        );

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
          total: json['count'],
          siguientePaginaUrl: json['next'],
          paginaAnteriorUrl: json['previous'],
          productos: List<ProductEntity>.from(
            json['results'].map((item) => ProductModel.fromJson(item)),
          ));

  Map<String, dynamic> toJson() => {
        'count': total,
        'next': siguientePaginaUrl,
        'previous': paginaAnteriorUrl,
        'results': List<dynamic>.from(
          productos.map((item) => (item as ProductModel).toJson()),
        ),
      };
}
