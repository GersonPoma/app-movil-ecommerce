import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:piiicks/application/notifications_cubit/notifications_cubit.dart';
import 'package:piiicks/application/share_cubit/share_cubit.dart';
import 'package:piiicks/configs/app.dart';
import 'package:piiicks/configs/configs.dart';
import 'package:piiicks/core/constant/assets.dart';
import 'package:piiicks/core/constant/colors.dart';

import 'package:piiicks/domain/entities/product/product.dart';
import 'package:piiicks/presentation/widgets/custom_appbar.dart';
import 'package:piiicks/presentation/widgets/photo_view_dialog.dart';
import 'package:piiicks/presentation/widgets/quantity_row.dart';

import '../../application/cart_bloc/cart_bloc.dart';
import '../../application/wishlist_cubit/wishlist_cubit.dart';
import '../../data/models/product/product_model.dart';
import '../../domain/entities/cart/cart_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/proceedtocart_modalsheet.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  PageController _pageController = PageController();
  ScrollController _listController = ScrollController();
  int _selectedPageIndex = 0;

  int cantidad = 1;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _selectedPageIndex = _pageController.page?.round() ?? 0;
        _listController.animateTo(
          _selectedPageIndex * 116.0,
          // Adjust this value based on your item width and margin
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);

    // Convertimos el ID a String porque tu cubit espera String
    bool isProductInWishlist = context
        .read<WishlistCubit>()
        .isInWishlist(widget.product.id.toString());

    return Scaffold(
      appBar: CustomAppBar(
        "DETALLES DEL PRODUCTO",
        context,
        doesHasCartIcom: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: Space.all(.9, .7),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.nombre.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppText.h2b,
              ),
              Space.yf(.6),
              Text(
                "${widget.product.precio} Bs",
                style: AppText.h3b?.copyWith(color: AppColors.CommonCyan),
              ),
              Space.yf(.6),
              Row(
                children: [
                  Text("Categoria: ", style: AppText.h3),
                  Text(
                    widget.product.nombreCategoria?.toUpperCase() ??
                        'SIN CATEGORIA',
                    style: AppText.h3b?.copyWith(color: AppColors.CommonCyan),
                  ),
                ],
              ),
              Space.yf(1.1),
              GestureDetector(
                onTap: () =>
                    showPhotoViewDialog(widget.product.imagenUrl, context),
                child: Hero(
                  tag: widget.product.id,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: widget.product.imagenUrl,
                    placeholder: (context, url) => placeholderShimmer(),
                  ),
                ),
              ),
              Space.yf(1.2),
              Text("Descripción", style: AppText.h3b),
              Space.yf(.5),
              Text(
                widget.product.descripcion,
                style:
                    AppText.b2?.copyWith(height: AppDimensions.normalize(.6)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.LightGrey,
        height: AppDimensions.normalize(33),
        padding: Space.all(.7, .9),
        margin: EdgeInsets.only(
          top: AppDimensions.normalize(1),
          bottom: AppDimensions.normalize(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuantityRow(
                width: 22,
                padding: 1,
                cantidad: cantidad,
                max: widget.product.stock,
                onChanged: (value) {
                  setState(() {
                    cantidad = value;
                  });
                }),
            SizedBox(
              width: AppDimensions.normalize(
                  70), // 🔥 Aquí defines el ancho deseado
              height: AppDimensions.normalize(
                  18), // 🔥 También podrías definir altura si quieres
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.normalize(4),
                    vertical: AppDimensions.normalize(2),
                  ),
                  backgroundColor:
                      AppColors.CommonCyan, // O el color que ya tengas
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  context.read<CartBloc>().add(
                        AddProduct(
                          cartItem: CartItem(
                            product: widget.product,
                            cantidad: cantidad,
                          ),
                          replaceQuantity: false,
                        ),
                      );
                  context.read<NotificationsCubit>().showAndSaveNotification(
                        "Carrito Actualizado",
                        "Has añadido ${widget.product.nombre} a tu carrito.",
                      );
                  showPoceedtoCartBottomSheet(context);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Añadir al carrito",
                    style: AppText.h3b?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
