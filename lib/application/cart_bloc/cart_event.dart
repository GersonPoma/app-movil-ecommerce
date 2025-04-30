part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class GetCart extends CartEvent {
  const GetCart();

  @override
  List<Object> get props => [];
}

class AddProduct extends CartEvent {
  final CartItem cartItem;
  final bool replaceQuantity; // 👈 NUEVO
  const AddProduct({
    required this.cartItem,
    this.replaceQuantity = false, // 👈 Por defecto es false (sumar)
  });

  @override
  List<Object> get props => [cartItem];
}

class ClearCart extends CartEvent {
  const ClearCart();
  @override
  List<Object> get props => [];
}

class DeleteProduct extends CartEvent {
  final String cartItemId;

  const DeleteProduct(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}
