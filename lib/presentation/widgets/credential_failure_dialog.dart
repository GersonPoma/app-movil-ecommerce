import 'package:flutter/material.dart';

import '../../configs/configs.dart';
import '../../core/constant/colors.dart';

Future<void> showCredentialErrorDialog(BuildContext context) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: AppDimensions.normalize(60),
            padding: Space.all(1, .5),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¡Nombre de usuario/contraseña incorrectos!",
                    style: AppText.b1b,
                  ),
                  Space.yf(.5),
                  Text(
                    "¡Intentar otra vez!",
                    style: AppText.b1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cerrar",
                            style: AppText.h3b?.copyWith(
                              color: AppColors.CommonCyan,
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
