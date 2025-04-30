import '../../../domain/entities/category/category.dart';

class FilterProductParams {
  final String? keyword;
  final String? siguientePaginaUrl; // Guardamos la URL para la siguiente carga
  final List<Category> categories;

  const FilterProductParams({
    this.keyword,
    this.siguientePaginaUrl,
    this.categories = const [],
  });

  /// Convertimos los filtros en parámetros de URL
  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (keyword != null && keyword!.isNotEmpty) {
      params['search'] = keyword!;
    }

    if (categories.isNotEmpty) {
      // Suponiendo que tu backend acepte algo como ?categories=1,3,5
      params['categoria'] = categories.map((c) => c.id).join(',');
    }

    return params;
  }

  FilterProductParams copyWith({
    String? keyword,
    String? siguientePaginaUrl,
    List<Category>? categories,
  }) =>
      FilterProductParams(
        keyword: keyword ?? this.keyword,
        siguientePaginaUrl: siguientePaginaUrl ?? this.siguientePaginaUrl,
        categories: categories ?? this.categories,
      );
}
