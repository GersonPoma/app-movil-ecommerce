import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piiicks/domain/usecases/cart/delete_cart_item_usecase.dart';
import 'package:piiicks/domain/usecases/cart/update_cart_item_usecase.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/cart/cart_item.dart';
import '../../../domain/usecases/cart/add_cart_item_usecase.dart';
import '../../../domain/usecases/cart/clear_cart_usecase.dart';
import '../../../domain/usecases/cart/get_cached_cart_usecase.dart';
import '../../../domain/usecases/cart/sync_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCachedCartUseCase _getCachedCartUseCase;
  final AddCartUseCase _addCartUseCase;
  final SyncCartUseCase _syncCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final DeleteCartItemUseCase _deleteCartItemUseCase;
  final UpdateCartItemUseCase _updateCartItemUseCase;

  CartBloc(
    this._getCachedCartUseCase,
    this._addCartUseCase,
    this._syncCartUseCase,
    this._clearCartUseCase,
    this._deleteCartItemUseCase,
    this._updateCartItemUseCase,
  ) : super(const CartInitial(cart: [])) {
    on<GetCart>(_onGetCart);
    on<AddProduct>(_onAddToCart);
    on<ClearCart>(_onClearCart);
    // Si implementas eliminación:
    on<DeleteProduct>(_onDeleteProduct);
  }

  void _onGetCart(GetCart event, Emitter<CartState> emit) async {
    emit(CartLoading(cart: state.cart));

    // final result = await _getCachedCartUseCase(NoParams());
    // result.fold(
    //   (failure) {
    //     emit(CartError(cart: state.cart, failure: failure));
    //   },
    //   (cart) {
    //     emit(CartLoaded(cart: cart));
    //   },
    // );

    final syncResult = await _syncCartUseCase(NoParams());
    syncResult.fold(
      (failure) {
        emit(CartError(cart: state.cart, failure: failure));
      },
      (cart) {
        emit(CartLoaded(cart: cart));
      },
    );
  }

  void _onAddToCart(AddProduct event, Emitter<CartState> emit) async {
    emit(CartLoading(cart: state.cart));
    List<CartItem> cart = List.from(state.cart);

    final index =
        cart.indexWhere((item) => item.product.id == event.cartItem.product.id);

    if (index != -1) {
      final newCantidad = event.replaceQuantity
          ? event.cartItem.cantidad // Reemplazar directamente
          : cart[index].cantidad + event.cartItem.cantidad; // Sumar cantidad

      if (newCantidad > 0) {
        // 🔥 Actualiza localmente primero (sin mostrar loading)
        cart[index] = CartItem(
          id: cart[index].id,
          product: cart[index].product,
          cantidad: newCantidad,
        );

        emit(CartLoaded(cart: cart));

        // Luego actualiza en backend en segundo plano
        final result = await _updateCartItemUseCase(cart[index]);

        result.fold(
          (failure) => emit(CartError(cart: state.cart, failure: failure)),
          (_) async {
            final syncResult = await _syncCartUseCase(NoParams());
            syncResult.fold(
              (failure) => emit(CartError(cart: state.cart, failure: failure)),
              (cart) => emit(CartLoaded(cart: cart)),
            );
          },
        );
      } else {
        // 🔥 Si la nueva cantidad es 0, eliminamos
        add(DeleteProduct(cart[index].id!));
      }
    } else {
      final result = await _addCartUseCase(event.cartItem);
      result.fold(
        (failure) => emit(CartError(cart: state.cart, failure: failure)),
        (_) async {
          final syncResult = await _syncCartUseCase(NoParams());
          syncResult.fold(
            (failure) => emit(CartError(cart: state.cart, failure: failure)),
            (cart) => emit(CartLoaded(cart: cart)),
          );
        },
      );
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(const CartLoading(cart: []));
    await _clearCartUseCase(NoParams());
    emit(const CartLoaded(cart: []));
  }

  // Opcional: Manejo de eliminación individual

  // void _onDeleteProduct(DeleteProduct event, Emitter<CartState> emit) async {
  //   emit(CartLoading(cart: state.cart));
  //   List<CartItem> updatedCart = List.from(state.cart)
  //     ..removeWhere((item) => item.id == event.cartItemId);
  //   emit(CartLoaded(cart: updatedCart));
  // }

  void _onDeleteProduct(DeleteProduct event, Emitter<CartState> emit) async {
    emit(CartLoading(cart: state.cart));

    var result = await _deleteCartItemUseCase(event.cartItemId);

    result.fold(
      (failure) => emit(CartError(cart: state.cart, failure: failure)),
      (_) {
        List<CartItem> updatedCart = List.from(state.cart)
          ..removeWhere((item) => item.id == event.cartItemId);
        emit(CartLoaded(cart: updatedCart));
      },
    );
  }
}
