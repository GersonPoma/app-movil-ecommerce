import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String nombre;
  final String imagenUrl;

  const Category({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
  });

  @override
  List<Object?> get props => [id];
}
