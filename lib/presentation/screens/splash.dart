import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piiicks/configs/configs.dart';
import 'package:piiicks/core/constant/assets.dart';
import 'package:piiicks/core/router/app_router.dart';
import '../../configs/app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _nextScreen() async {
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (!mounted) return; // 🔥 Aseguramos que el widget sigue montado

    if (token != null) {
      // Hay sesión iniciada ➔ ir al Home
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.root, // 🔴 Asegúrate de que esta ruta exista en AppRouter
        (route) => false,
      );
    } else {
      // No hay sesión ➔ ir al Login
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login, // 🔴 Asegúrate de que esta ruta exista en AppRouter
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nextScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            AppAssets.Splash,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: AppDimensions.normalize(200),
            left: AppDimensions.normalize(70),
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
