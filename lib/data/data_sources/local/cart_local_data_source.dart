import 'package:piiicks/data/models/product/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/failures.dart';
import '../../models/cart/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCart();
  Future<void> saveCart(List<CartItemModel> cart);
  Future<void> saveCartItem(CartItemModel cartItem);
  Future<bool> clearCart();
  Future<void> deleteCartItem(String cartItemId);
}

const cachedCart = 'CACHED_CART';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveCart(List<CartItemModel> cart) {
    return sharedPreferences.setString(
      cachedCart,
      cartItemModelToJson(cart),
    );
  }

  @override
  Future<void> saveCartItem(CartItemModel cartItem) {
    final jsonString = sharedPreferences.getString(cachedCart);
    final List<CartItemModel> cart = [];

    if (jsonString != null) {
      cart.addAll(cartItemModelListFromLocalJson(jsonString));
    }

    // Verificar si ya existe el producto con la misma cantidad
    bool exists = false;

    for (int i = 0; i < cart.length; i++) {
      if (cart[i].product.id == cartItem.product.id) {
        cart[i] = CartItemModel(
          id: cart[i].id,
          product: cart[i].product as ProductModel, // Cast seguro
          cantidad: cart[i].cantidad + cartItem.cantidad,
          fechaAgregado: cart[i].fechaAgregado,
        );
        exists = true;
        break;
      }
    }

    if (!exists) {
      cart.add(cartItem);
    }

    return sharedPreferences.setString(
      cachedCart,
      cartItemModelToJson(cart),
    );
  }

  @override
  Future<List<CartItemModel>> getCart() {
    final jsonString = sharedPreferences.getString(cachedCart);
    if (jsonString != null) {
      return Future.value(cartItemModelListFromLocalJson(jsonString));
    } else {
      throw CacheFailure();
    }
  }

  @override
  Future<bool> clearCart() async {
    return await sharedPreferences.remove(cachedCart);
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    final jsonString = sharedPreferences.getString(cachedCart);

    if (jsonString != null) {
      List<CartItemModel> cart = cartItemModelListFromLocalJson(jsonString);

      // Filtrar eliminando el item con el ID indicado
      cart.removeWhere((item) => item.id == cartItemId);

      await sharedPreferences.setString(
        cachedCart,
        cartItemModelToJson(cart),
      );
    } else {
      throw CacheFailure(); // No había carrito guardado
    }
  }
}
