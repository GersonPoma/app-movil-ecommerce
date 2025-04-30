import 'dart:convert';

import '../../../domain/entities/category/category.dart';

List<CategoryModel> categoryModelListFromRemoteJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

List<CategoryModel> categoryModelListFromLocalJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelListToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String nombre,
    required String imagenUrl,
  }) : super(
          id: id,
          nombre: nombre,
          imagenUrl: imagenUrl,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] is int ? json["id"] : int.parse(json["id"].toString()),
        nombre: json["nombre"],
        imagenUrl: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen": imagenUrl,
      };

  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        nombre: entity.nombre,
        imagenUrl: entity.imagenUrl,
      );
}
