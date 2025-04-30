import '../../../domain/entities/product/product.dart';
import '../category/category_model.dart';
import 'price_tag_model.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required int id,
    required String nombre,
    required String descripcion,
    required double precio,
    required int stock,
    required String imagenUrl,
    required DateTime fechaCreacion,
    CategoryModel? categoria,
    String? nombreCategoria,
  }) : super(
          id: id,
          nombre: nombre,
          descripcion: descripcion,
          precio: precio,
          stock: stock,
          imagenUrl: imagenUrl,
          fechaCreacion: fechaCreacion,
          categoria: categoria,
          nombreCategoria: nombreCategoria,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        precio: double.parse(json['precio']),
        stock: json['stock'],
        imagenUrl: json['imagen'],
        fechaCreacion: DateTime.parse(json['fecha_creacion']),
        nombreCategoria: json['nombre_categoria'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio.toString(),
        'stock': stock,
        'imagen': imagenUrl,
        'fecha_creacion': fechaCreacion.toIso8601String(),
      };

  factory ProductModel.fromEntity(ProductEntity entity) => ProductModel(
        id: entity.id,
        nombre: entity.nombre,
        descripcion: entity.descripcion,
        precio: entity.precio,
        stock: entity.stock,
        imagenUrl: entity.imagenUrl,
        fechaCreacion: entity.fechaCreacion,
        nombreCategoria: entity.nombreCategoria,
      );
}
