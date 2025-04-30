import 'product.dart';

class ProductResponse {
  final List<ProductEntity> productos;
  final int total;
  final String? siguientePaginaUrl;
  final String? paginaAnteriorUrl;

  ProductResponse({
    required this.productos,
    required this.total,
    this.siguientePaginaUrl,
    this.paginaAnteriorUrl,
  });
}
