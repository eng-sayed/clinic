import 'dart:io';

import 'package:clinic/core/themes/colors.dart';
import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/presentaion/components/customtext.dart';
import 'package:clinic/presentaion/screens/profile/cubit/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/validation.dart';
import '../../../../data/local/sharedpreferences.dart';
import '../../../../domain/models/patient_model.dart';
import '../../../components/default_button.dart';
import '../../../components/login_text_failed.dart';
import '../../../components/navigator.dart';
import '../../../components/network_image.dart';
import '../../auth/screens/sign_up.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // TODO: implement initState

    emailController.text = Utiles.currentUser.email ?? '';
    nameController.text = Utiles.currentUser.name ?? '';
    ageController.text = (Utiles.currentUser.age.toString()) == 'null'
        ? ''
        : Utiles.currentUser.age.toString();
    phoneController.text = Utiles.currentUser.phone ?? '';
    super.initState();
  }

  final TextEditingController emailController = TextEditingController(),
      nameController = TextEditingController(),
      phoneController = TextEditingController(),
      ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ProfileCubit.get(context);

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await cubit.logout(context);
                  },
                ),
                title: CustomText(
                  "Profile",
                  color: AppColors.white,
                  textStyleEnum: TextStyleEnum.title,
                ),
                centerTitle: true,
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: NetworkImagesWidgets(
                          Utiles.currentUser.image ?? '',
                          width: 100,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                        ),
                        IconButton(
                          onPressed: () async {
                            await cubit.picedImage(context);
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: AppColors.buttonColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LoginTextField(
                      keyboardType: TextInputType.text,
                      controller: nameController,
                      label: 'Name',
                      validate: Validation().defaultValidation,
                    ),
                    LoginTextField(
                      keyboardType: TextInputType.number,
                      controller: ageController,
                      label: 'Age',
                      validate: Validation().defaultValidation,
                    ),
                    LoginTextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      label: 'Phone',
                      validate: Validation().defaultValidation,
                    ),
                    LoginTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      label: 'Email',
                      validate: Validation().emailValidation,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultButton(
                        function: () async {
                          PatientModel patientModel = PatientModel(
                              name: nameController.text,
                              age: int.tryParse(ageController.text),
                              phone: phoneController.text,
                              email: emailController.text,
                              fcmToken: Utiles.FCMToken);
                          await cubit.updateUserData(patientModel, context);
                        },
                        text: 'update',
                        background: AppColors.buttonColor,
                        width: 300.w),
                  ],
                ),
              )));
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
