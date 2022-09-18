import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/presentaion/screens/auth/screens/sign_in.dart';
import 'package:clinic/presentaion/screens/auth/screens/sign_up.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';
import '../../components/navigator.dart';
import '../../layout/layout.dart';
import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // final splashCubit = SplashCubit.get(context);
      // splashCubit.getToken();
      await _navigateToHome();
    });
    // FireBaseMessaging().initUniLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.loose,
      children: [
        Container(
          color: Colors.white,
        ),
        Image.asset(
          "assets/images/logo.png",
          width: 200,
        ),
        Positioned(
          top: -100,
          left: -100,
          child: CircleAvatar(
            radius: 100,
          ),
        ),
        Positioned(
          top: -110,
          left: -110,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.5),
            radius: 110,
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: AppColors.secondary,
          ),
        ),
        Positioned(
          bottom: -110,
          right: -110,
          child: CircleAvatar(
            backgroundColor: AppColors.secondary.withOpacity(0.5),
            radius: 114,
          ),
        )
      ],
    );
  }

  _navigateToHome() async {
    await Future.delayed(
      const Duration(milliseconds: 3000),
      () {},
    );
    Utiles.UID.isEmpty
        ? navigateReplacement(context: context, route: SignIn())
        : navigateReplacement(context: context, route: HomeLayout());
  }
}
