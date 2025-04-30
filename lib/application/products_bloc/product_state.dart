part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  final List<ProductEntity> products;
  final FilterProductParams params;
  final String? siguientePaginaUrl;

  const ProductState({
    required this.products,
    required this.params,
    required this.siguientePaginaUrl,
  });
}

class ProductInitial extends ProductState {
  const ProductInitial({
    required super.products,
    required super.params,
    required super.siguientePaginaUrl,
  });

  @override
  List<Object?> get props => [products, params, siguientePaginaUrl];
}

class ProductEmpty extends ProductState {
  const ProductEmpty({
    required super.products,
    required super.params,
    required super.siguientePaginaUrl,
  });

  @override
  List<Object?> get props => [products, params, siguientePaginaUrl];
}

class ProductLoading extends ProductState {
  const ProductLoading({
    required super.products,
    required super.params,
    required super.siguientePaginaUrl,
  });

  @override
  List<Object?> get props => [products, params, siguientePaginaUrl];
}

class ProductLoaded extends ProductState {
  const ProductLoaded({
    required super.products,
    required super.params,
    required super.siguientePaginaUrl,
  });

  @override
  List<Object?> get props => [products, params, siguientePaginaUrl];
}

class ProductError extends ProductState {
  final Failure failure;

  const ProductError({
    required super.products,
    required super.params,
    required super.siguientePaginaUrl,
    required this.failure,
  });

  @override
  List<Object?> get props => [products, params, siguientePaginaUrl, failure];
}
