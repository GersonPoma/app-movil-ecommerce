import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../configs/configs.dart';
import '../../core/constant/assets.dart';
import '../../core/constant/colors.dart';

Widget QuantityRow({
  required double width,
  required double padding,
  int cantidad = 1,
  int min = 0,
  int? max,
  required Function(int) onChanged,
}) {
  return Container(
    width: AppDimensions.normalize(width * 3), // Ancho total controlado
    height: AppDimensions.normalize(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: cantidad > min ? () => onChanged(cantidad - 1) : null,
          child: Container(
            width: AppDimensions.normalize(width),
            color: AppColors.CommonCyan,
            child: Center(
              child: SvgPicture.asset(AppAssets.Minus,
                  color: Colors.white, height: 3),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: Space.hf(padding),
            color: Colors.white,
            child: Center(
              child: FittedBox(
                // 👈 Esto hace que se ajuste al espacio disponible
                fit: BoxFit.scaleDown,
                child: Text(
                  cantidad.toString(),
                  style: AppText.h3b?.copyWith(
                    fontSize:
                        AppDimensions.normalize(8), // 👈 Baja un poco el tamaño
                  ),
                  maxLines: 1, // 👈 No dejar que pase a segunda línea
                  overflow:
                      TextOverflow.ellipsis, // 👈 Si pasa de espacio, recorta
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (max == null || cantidad < max)
              ? () => onChanged(cantidad + 1)
              : null,
          child: Container(
            width: AppDimensions.normalize(width),
            color: AppColors.CommonCyan,
            child: Center(
              child: SvgPicture.asset(AppAssets.Plus,
                  color: Colors.white, height: 13),
            ),
          ),
        ),
      ],
    ),
  );
}
