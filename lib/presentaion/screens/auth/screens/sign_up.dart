import 'package:auth_buttons/auth_buttons.dart';
import 'package:clinic/core/themes/colors.dart';
import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/core/utils/validation.dart';
import 'package:clinic/domain/models/patient_model.dart';
import 'package:clinic/presentaion/components/navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../components/customtext.dart';
import '../../../components/default_button.dart';
import '../../../components/login_text_failed.dart';
import '../cubit/auth_cubit.dart';
import 'sign_in.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      nameController = TextEditingController(),
      phoneController = TextEditingController(),
      ageController = TextEditingController();
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
                    "تسجيل جديد",
                    fontsize: 50,
                    color: AppColors.black,
                    weight: FontWeight.bold,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    label: 'الاسم',
                    validate: Validation().defaultValidation,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    label: 'العمر',
                    validate: Validation().defaultValidation,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    label: 'رقم الهاتف',
                    validate: Validation().defaultValidation,
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
                    label: 'كلمة المرور',
                    validate: Validation().passwordValidation,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                      function: () async {
                        if (_formKey.currentState!.validate()) {
                          PatientModel patientModel = PatientModel(
                              name: nameController.text,
                              age: int.tryParse(ageController.text),
                              phone: phoneController.text,
                              email: emailController.text,
                              fcmToken: Utiles.FCMToken);
                          await cubit.register(
                              patientModel, passwordController.text, context);
                        }
                      },
                      text: 'تسجيل',
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
                  GoogleAuthButton(
                    onPressed: () async {
                      await cubit.registerByGoogle(context);
                    },
                    text: 'تسجيل جديد بواسطه جوجل',
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
                        "اذا كنت تمتلك حساب بالفعل",
                        color: AppColors.greyText,
                        fontsize: 18,
                      ),
                      InkWell(
                        onTap: () {
                          navigate(context: context, route: SignIn());
                        },
                        child: CustomText(
                          " تسجيل الدخول",
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
