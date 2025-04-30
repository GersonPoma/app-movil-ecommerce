import 'package:equatable/equatable.dart';

import '../category/category.dart';
import 'price_tag.dart';

class ProductEntity extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String imagenUrl;
  final DateTime fechaCreacion;
  final Category? categoria;
  final String? nombreCategoria;

  const ProductEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.imagenUrl,
    required this.fechaCreacion,
    this.categoria,
    this.nombreCategoria,
  });

  @override
  List<Object?> get props => [id];
}
