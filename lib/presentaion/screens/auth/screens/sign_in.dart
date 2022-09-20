import 'package:auth_buttons/auth_buttons.dart';
import 'package:clinic/core/themes/colors.dart';
import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/core/utils/validation.dart';
import 'package:clinic/presentaion/screens/auth/screens/phone_auth.dart';
import 'package:clinic/presentaion/screens/auth/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../components/customtext.dart';
import '../../../components/default_button.dart';
import '../../../components/login_text_failed.dart';
import '../../../components/navigator.dart';
import '../cubit/auth_cubit.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return Scaffold(
            body: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "تسجيل الدخول",
                    fontsize: 50,
                    color: AppColors.black,
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    label: 'البريد الالكتروني',
                    validate: Validation().emailValidation,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    label: 'كلمه المرور',
                    validate: Validation().passwordValidation,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          await cubit.login(emailController.text,
                              passwordController.text, context);
                        }
                      },
                      text: 'تسجيل الدخول',
                      background: AppColors.buttonColor,
                      width: 300.w),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomText(
                      "او",
                      color: AppColors.black,
                      fontsize: 18,
                    ),
                  ),
                  defaultButton(
                      function: () {
                        navigate(context: context, route: PhoneLogin());
                      },
                      text: 'تسجيل بواسطه الهاتف',
                      background: AppColors.buttonColor,
                      width: 300.w),
                  SizedBox(
                    height: 15,
                  ),
                  GoogleAuthButton(
                    text: 'تسجيل الدخول بواسطه جوجل',
                    onPressed: () async {
                      await cubit.loginByGoogle(context);
                    },
                    style: AuthButtonStyle(
                      iconType: AuthIconType.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomText(
                        "الا تملك بريد الكتروني",
                        color: AppColors.greyText,
                        fontsize: 18,
                      ),
                      InkWell(
                        onTap: () {
                          navigate(context: context, route: SignUpPage());
                        },
                        child: CustomText(
                          " تسجيل جديد",
                          weight: FontWeight.bold,
                          color: AppColors.greyText,
                          fontsize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
