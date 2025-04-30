import 'package:equatable/equatable.dart';

import '../product/price_tag.dart';
import '../product/product.dart';

class CartItem extends Equatable {
  final String? id; // ID del ítem en el carrito (desde backend)
  final ProductEntity product; // Producto completo
  final int cantidad; // Cantidad de unidades

  const CartItem({
    this.id,
    required this.product,
    required this.cantidad,
  });

  @override
  List<Object?> get props => [id, product, cantidad];
}

enum TipoEntrega { retiroEnTienda, envioDomicilio }

class CartUtils {
  /// Calcula el subtotal (sin envío, sin descuentos)
  static double calcularSubtotal(List<CartItem> cart) {
    return cart.fold(
        0.0, (total, item) => total + (item.product.precio * item.cantidad));
  }

  /// Calcula el total (incluyendo envío fijo, descuentos, etc.)
  static double calcularTotal(
    List<CartItem> cart, {
    TipoEntrega tipoEntrega = TipoEntrega.retiroEnTienda,
    double shippingFee = 5.0,
    double discount = 0.0,
  }) {
    double subtotal = calcularSubtotal(cart);

    double costoEnvio = 0.0;

    if (tipoEntrega == TipoEntrega.envioDomicilio) {
      costoEnvio = shippingFee;
    } // Si es retiro en tienda, el costo de envío queda en 0

    return subtotal + costoEnvio - discount;
  }
}
