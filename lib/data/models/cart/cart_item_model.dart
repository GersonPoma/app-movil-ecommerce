import 'dart:convert';

import '../../../domain/entities/cart/cart_item.dart';
import '../product/product_model.dart';

List<CartItemModel> cartItemModelListFromLocalJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str).map((x) => CartItemModel.fromJson(x)));

List<CartItemModel> cartItemModelListFromRemoteJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str).map((x) => CartItemModel.fromJson(x)));

List<CartItemModel> cartItemModelFromJson(String str) =>
    List<CartItemModel>.from(
        json.decode(str).map((x) => CartItemModel.fromJson(x)));

String cartItemModelToJson(List<CartItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartItemModel extends CartItem {
  final String? fechaAgregado;

  const CartItemModel({
    String? id,
    required ProductModel product,
    required int cantidad,
    this.fechaAgregado,
  }) : super(id: id, product: product, cantidad: cantidad);

  /// Convertir desde JSON (respuesta del backend)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["id"]?.toString(),
      product: ProductModel.fromJson(json["producto"]),
      cantidad: json["cantidad"],
      fechaAgregado: json["fecha_agregado"],
    );
  }

  /// Para guardar localmente o manipular internamente
  Map<String, dynamic> toJson() => {
        "id": id,
        "producto": (product as ProductModel).toJson(),
        "cantidad": cantidad,
        "fecha_agregado": fechaAgregado,
      };

  /// Para enviar al backend (POST/PUT)
  Map<String, dynamic> toBodyJson() => {
        "producto_id": product.id,
        "cantidad": cantidad,
      };

  factory CartItemModel.fromParent(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id.toString(),
      product: cartItem.product as ProductModel,
      cantidad: cartItem.cantidad,
    );
  }
}
