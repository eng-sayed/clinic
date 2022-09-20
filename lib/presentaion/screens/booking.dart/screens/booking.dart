import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/core/utils/validation.dart';
import 'package:clinic/presentaion/components/customtext.dart';
import 'package:clinic/presentaion/screens/booking.dart/cubit/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/themes/colors.dart';
import '../../../../domain/models/booking_model.dart';
import '../../../components/default_button.dart';
import '../../../components/login_text_failed.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = BookingCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: CustomText(
                'طلب حجز',
                fontsize: 20,
                color: AppColors.white,
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            LoginTextField(
                              label: 'الاسم',
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validate: Validation().defaultValidation,
                            ),
                            LoginTextField(
                              keyboardType: TextInputType.number,
                              label: 'العمر',
                              controller: ageController,
                              validate: Validation().defaultValidation,
                            ),
                            LoginTextField(
                              keyboardType: TextInputType.phone,
                              label: 'رقم الهاتف',
                              controller: phoneController,
                              validate: Validation().defaultValidation,
                            ),
                            LoginTextField(
                              maxlines: 3,
                              keyboardType: TextInputType.text,
                              label: 'ملاحظات',
                              controller: commentController,
                              validate: Validation().defaultValidation,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            defaultButton(
                                function: () async {
                                  if (_formKey.currentState!.validate()) {
                                    BookingModel bookingModel = BookingModel(
                                        name: nameController.text,
                                        age: ageController.text,
                                        phone: phoneController.text,
                                        comment: commentController.text.isEmpty
                                            ? 'لا يوجد'
                                            : commentController.text,
                                        uid: Utiles.UID);
                                    await cubit.AddingOrder(
                                        context, bookingModel);
                                  }
                                },
                                text: 'حجز',
                                background: AppColors.buttonColor,
                                width: 300.w)
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
