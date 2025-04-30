import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piiicks/configs/app_typography.dart';
import 'package:piiicks/configs/configs.dart';
import 'package:piiicks/core/constant/colors.dart';
import 'package:piiicks/presentation/widgets/auth_error_dialog.dart';
import 'package:piiicks/presentation/widgets/credential_failure_dialog.dart';
import 'package:piiicks/presentation/widgets/custom_appbar.dart';
import 'package:piiicks/presentation/widgets/successful_auth_dialog.dart';
import 'package:piiicks/presentation/widgets/transparent_button.dart';

import '../../application/user_bloc/user_bloc.dart';
import '../../core/error/failures.dart';
import '../../core/router/app_router.dart';
import '../../domain/usecases/user/sign_up_usecase.dart';
import '../widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

//  bool isLoading = false;
  bool isChecked = false;

  /* void _startLoading() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 15), () {
      setState(() {
        isLoading = false;
      });
    });
  }*/
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar("REGISTRARSE", context, automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: Space.all(1, 1.3),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "REGISTRARSE",
                  style: AppText.h2b?.copyWith(color: AppColors.CommonCyan),
                ),
                Space.y!,
                Text(
                  "Crearse Nueva Cuenta",
                  style: AppText.h3?.copyWith(color: AppColors.GreyText),
                ),
                Space.y2!,
                Text(
                  "Nombre de usuario*",
                  style: AppText.b1b,
                ),
                Space.y!,
                buildTextFormField(_usernameController, "Username"),
                Space.yf(1.5),
                Text(
                  "Correo Electrónico*",
                  style: AppText.b1b,
                ),
                Space.y!,
                buildTextFormField(_emailController, "Email"),
                Space.yf(1.5),
                Text(
                  "Contraseña*",
                  style: AppText.b1b,
                ),
                Space.y!,
                buildTextFormField(_passwordController, "Contraseña",
                    isObscure: true),
                Space.yf(1.5),
                Text(
                  "Confirmar Contraseña*",
                  style: AppText.b1b,
                ),
                Space.y!,
                buildTextFormField(_confirmPasswordController, "Contraseña",
                    isObscure: true),
                Space.yf(1.5),
                BlocConsumer<UserBloc, UserState>(
                  listener: (context, state) {
                    if (state is UserLogged) {
                      showSuccessfulAuthDialog(context, "Registrado");
                    } else if (state is UserLoggedFail) {
                      if (state.failure is CredentialFailure) {
                        showCredentialErrorDialog(context);
                      } else {
                        showAuthErrorDialog(context);
                      }
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                          } else {
                            context.read<UserBloc>().add(
                                  SignUpUser(
                                    SignUpParams(
                                      username: _usernameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  ),
                                );
                          }
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(
                          Size(
                            double.infinity,
                            AppDimensions.normalize(20),
                          ),
                        ),
                      ),
                      child: Text(
                        (state is UserLoading) ? "Espera..." : "Registrarse",
                        style: AppText.h3b?.copyWith(color: Colors.white),
                      ),
                    );
                  },
                ),
                Space.yf(1.5),
                Center(
                    child: Text(
                  "¿Ya tienes una cuenta?",
                  style: AppText.b1b,
                )),
                Space.y1!,
                transparentButton(
                    context: context,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRouter.login);
                    },
                    buttonText: "Iniciar Sesion")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
