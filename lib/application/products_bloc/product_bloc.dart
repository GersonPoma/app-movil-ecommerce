import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/product/pagination_meta_data.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../core/enums/enums.dart';
import '../../core/error/failures.dart';
import '../../data/models/product/filter_params_model.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductUseCase _getProductUseCase;

  ProductBloc(this._getProductUseCase)
      : super(const ProductInitial(
          products: [],
          params: FilterProductParams(),
          siguientePaginaUrl: null,
        )) {
    on<GetProducts>(_onLoadProducts);
    on<GetMoreProducts>(_onLoadMoreProducts);
    on<SortProducts>(_onSortProducts);
  }

  void _onLoadProducts(GetProducts event, Emitter<ProductState> emit) async {
    try {
      emit(ProductLoading(
        products: [],
        params: event.params,
        siguientePaginaUrl: null,
      ));
      final result = await _getProductUseCase(event.params);
      result.fold(
        (failure) => emit(ProductError(
          products: [],
          failure: failure,
          params: event.params,
          siguientePaginaUrl: null,
        )),
        (productResponse) => emit(ProductLoaded(
          products: productResponse.productos,
          params: event.params,
          siguientePaginaUrl: productResponse.siguientePaginaUrl,
        )),
      );
    } catch (e) {
      emit(ProductError(
        products: [],
        failure: ExceptionFailure(),
        params: event.params,
        siguientePaginaUrl: null,
      ));
    }
  }

  void _onSortProducts(SortProducts event, Emitter<ProductState> emit) {
    if (event.sortOrder != null && state is ProductLoaded) {
      final sortedProducts = List<ProductEntity>.from(state.products);

      sortedProducts.sort((a, b) {
        switch (event.sortOrder!) {
          case SortOrder.newest:
            return b.fechaCreacion.compareTo(a.fechaCreacion);
          case SortOrder.highToLow:
            return b.precio.compareTo(a.precio);
          case SortOrder.lowToHigh:
            return a.precio.compareTo(b.precio);
          case SortOrder.aToZ:
            return a.nombre.compareTo(b.nombre);
          case SortOrder.zToA:
            return b.nombre.compareTo(a.nombre);
        }
      });

      emit(ProductLoaded(
        products: sortedProducts,
        params: state.params,
        siguientePaginaUrl: (state as ProductLoaded).siguientePaginaUrl,
      ));
    }
  }

  void _onLoadMoreProducts(
      GetMoreProducts event, Emitter<ProductState> emit) async {
    var currentState = state;

    if (currentState is ProductLoaded) {
      if (currentState.siguientePaginaUrl == null) {
        // No hay más páginas que cargar
        return;
      }

      try {
        emit(ProductLoading(
          products: currentState.products,
          params: currentState.params,
          siguientePaginaUrl: currentState.siguientePaginaUrl,
        ));

        // Incrementamos la página
        final result =
            await _getProductUseCase.fromUrl(currentState.siguientePaginaUrl!);

        result.fold(
          (failure) => emit(ProductError(
            products: currentState.products,
            failure: failure,
            params: currentState.params,
            siguientePaginaUrl: currentState.siguientePaginaUrl,
          )),
          (productResponse) {
            final updatedProducts =
                List<ProductEntity>.from(currentState.products)
                  ..addAll(productResponse.productos);

            emit(ProductLoaded(
              products: updatedProducts,
              params: currentState.params,
              siguientePaginaUrl: productResponse.siguientePaginaUrl,
            ));
          },
        );
      } catch (e) {
        emit(ProductError(
          products: currentState.products,
          failure: ExceptionFailure(),
          params: currentState.params,
          siguientePaginaUrl: currentState.siguientePaginaUrl,
        ));
      }
    }
  }
}
