import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/data/local/sharedpreferences.dart';
import 'package:clinic/presentaion/components/customtext.dart';
import 'package:clinic/presentaion/components/navigator.dart';
import 'package:clinic/presentaion/screens/auth/screens/sign_up.dart';
import 'package:clinic/presentaion/screens/booking.dart/screens/booking.dart';
import 'package:clinic/presentaion/screens/home/cubit/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../core/themes/colors.dart';
import '../../components/default_button.dart';
import '../../components/shimer_loading_items.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    final cubit = HomeCubit.get(context);
    Future.wait([cubit.getSliders(), cubit.getPatientData()]);
    // cubit.getSliders();
    // cubit.getPatientData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = HomeCubit.get(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: FutureBuilder(
                  future: cubit.getSliders(),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting ||
                        cubit.sliders.isEmpty) {
                      return TrendingLoadingItem();
                    }
                    return CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 3.0,
                        enlargeCenterPage: true,
                        height: 280.h,
                      ),
                      items: cubit.sliders
                          .map((item) => Container(
                                child: Center(
                                    child: Image.network(
                                  item,
                                  fit: BoxFit.cover,
                                  width: 600.w,
                                  height: 380.h,
                                )),
                              ))
                          .toList(),
                    );
                  }),
            ),
            SizedBox(
              height: 90.h,
            ),
            defaultButton(
                function: () {
                  navigate(context: context, route: Booking());
                },
                text: 'طلب حجز',
                background: AppColors.buttonColor,
                width: 300.w),
            SizedBox(
              height: 90.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CustomText(
                      'رقم حجزك',
                      color: AppColors.greyText,
                      fontsize: 20,
                    ),
                    CustomText(
                      '7',
                      color: AppColors.greyText,
                      fontsize: 20,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomText(
                      'الرقم الحالي',
                      color: AppColors.greyText,
                      fontsize: 20,
                    ),
                    CustomText(
                      '3',
                      color: AppColors.greyText,
                      fontsize: 20,
                      weight: FontWeight.w700,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
