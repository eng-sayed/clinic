import 'dart:convert';

import 'package:clinic/core/themes/colors.dart';
import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/core/utils/validation.dart';
import 'package:clinic/presentaion/components/default_button.dart';
import 'package:clinic/presentaion/components/login_text_failed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/utils/utiles.dart';
import '../../../../data/local/sharedpreferences.dart';
import '../../../../domain/models/patient_model.dart';
import '../../../components/customtext.dart';
import '../../../components/myLoading.dart';
import '../../../layout/layout.dart';
import '../cubit/auth_cubit.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({Key? key}) : super(key: key);

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AuthCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              backgroundColor: AppColors.white,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            ),
            body: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    'تسجيل الدخول',
                    fontsize: 50,
                    color: AppColors.black,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 150.h,
                  ),
                  Column(
                    children: [
                      LoginTextField(
                        controller: phoneController,
                        label: "رقم الهاتف",
                        keyboardType: TextInputType.phone,
                        validate: Validation().defaultValidation,
                      ),
                      Visibility(
                        child: LoginTextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          label: "رمز التاكيد",
                          validate: Validation().defaultValidation,
                        ),
                        visible: state is VisiabilitySuceed,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                          width: 300.w,
                          function: () {
                            state is VisiabilitySuceed
                                ? cubit.signIn(context, phoneController.text,
                                    otpController)
                                : cubit.verifyPhone(
                                    phoneController.text, context);
                          },
                          text: state is VisiabilitySuceed
                              ? "تاكيد"
                              : 'تسجيل الدخول',
                          background: AppColors.buttonColor),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
