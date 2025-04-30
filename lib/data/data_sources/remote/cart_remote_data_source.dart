import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/api.dart';
import '../../models/cart/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<CartItemModel> addToCart(CartItemModel cartItem, String token);
  Future<List<CartItemModel>> syncCart(List<CartItemModel> cart, String token);
  Future<void> deleteCartItem(String cartItemId, String token);
  Future<void> updateCartItem(CartItemModel cartItem, String token);
}

class CartRemoteDataSourceSourceImpl implements CartRemoteDataSource {
  final http.Client client;
  CartRemoteDataSourceSourceImpl({required this.client});

  @override
  Future<CartItemModel> addToCart(CartItemModel cartItem, String token) async {
    final response = await client.post(
      Uri.parse('$baseUrl/carrito/carritos/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cartItem.toBodyJson()),
    );

    if (response.statusCode == 201) {
      // Django REST Framework responde 201 Created
      return CartItemModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  /// Actualizar la cantidad de un ítem existente en el carrito (PATCH)
  @override
  Future<void> updateCartItem(CartItemModel cartItem, String token) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/carrito/carritos/${cartItem.id}/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "cantidad": cartItem.cantidad,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  /// Obtener el carrito completo (sincronización)
  @override
  Future<List<CartItemModel>> syncCart(
      List<CartItemModel> cart, String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/carrito/carritos/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> items = decoded['results'];

      return items.map((e) => CartItemModel.fromJson(e)).toList();
    } else {
      throw ServerException();
    }
  }

  /// Eliminar un producto del carrito
  @override
  Future<void> deleteCartItem(String cartItemId, String token) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/carrito/carritos/$cartItemId/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      // Django REST Framework responde 204 No Content
      throw ServerException();
    }
  }
}
