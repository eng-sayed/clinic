import 'package:clinic/presentaion/screens/profile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/themes/colors.dart';
import 'widget/bottom_navbar.dart';
import 'widget/exit_dialog.dart';
import '../screens/home/home.dart';
import 'cubit/layout_cubit.dart';
import 'cubit/layout_states.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final cubit = HomeLayoutCubit.get(context);
    cubit.tabController =
        TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = HomeLayoutCubit.get(context);
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return
              //  WillPopScope(
              //   onWillPop: () async {
              //     return await showDialog(
              //         context: context, builder: (context) => ExitDialog());
              //   },
              //   child:

              Container(
            color: AppColors.primiry,
            child: SafeArea(
              top: false,
              child: Scaffold(
                // floatingActionButtonLocation:
                //     FloatingActionButtonLocation.centerDocked,
                // floatingActionButton: MyFloatActionButton(),
                extendBody: true,
                // appBar:
                //     // cubit.tabController.index == 3
                //     //     ? null
                //     //     :
                //     AppBar(
                //   title: Image(
                //     color: AppColors.white,
                //     image: AssetImage(
                //       "assets/images/logo.png",
                //     ),
                //     height: 50,
                //   ),
                //   centerTitle: true,
                //   // leading: IconButton(
                //   //   icon: Icon(Ionicons.menu),
                //   //   onPressed: () {
                //   //     zoomDrawerController.toggle?.call();
                //   //   },
                //   // ),
                // ),
                body: TabBarView(
                  controller: cubit.tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Home(),
                    ProfilePage(),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavBar(cubit),
              ),
            ),
            //  ),
          );
        });
  }
}
