import 'package:clinic/core/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';

class BackgroundWidget extends StatelessWidget {
  BackgroundWidget({Key? key, required this.child}) : super(key: key);
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: -60.w,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.7),
            radius: 60.fs,
          ),
        ),
        Positioned(
          top: 10.h,
          left: 60.w,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.8),
            radius: 20.fs,
          ),
        ),
        Positioned(
          bottom: 5.h,
          left: 60.w,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.6),
            radius: 10.fs,
          ),
        ),
        Positioned(
          bottom: 5.h,
          right: 20.w,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.9),
            radius: 40.fs,
          ),
        ),
        Positioned(
          bottom: 150.h,
          left: -40.w,
          child: CircleAvatar(
            backgroundColor: AppColors.primiry.withOpacity(0.5),
            radius: 40.fs,
          ),
        ),
        child
      ],
    );
  }
}

class AnimatedBackgroundWidget extends StatefulWidget {
  AnimatedBackgroundWidget({Key? key, required this.child}) : super(key: key);
  Widget child;

  @override
  State<AnimatedBackgroundWidget> createState() =>
      _AnimatedBackgroundWidgetState();
}

class _AnimatedBackgroundWidgetState extends State<AnimatedBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> moveCircle;
  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 4000), vsync: this);
    moveCircle = Tween<double>(begin: 0, end: 1).animate(animationController);
    animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: moveCircle,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                right: -60.w,
                top: (20 * moveCircle.value),
                child: CircleAvatar(
                  backgroundColor: AppColors.primiry.withOpacity(0.7),
                  radius: 60.fs,
                ),
              ),
              Positioned(
                top: 10.h + (25 * moveCircle.value),
                left: 60.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.primiry.withOpacity(0.8),
                  radius: 20.fs,
                ),
              ),
              Positioned(
                bottom: 5.h + (15 * moveCircle.value),
                left: 60.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.primiry.withOpacity(0.6),
                  radius: 10.fs,
                ),
              ),
              Positioned(
                bottom: 5.h + (10 * moveCircle.value),
                right: 20.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.primiry.withOpacity(0.9),
                  radius: 40.fs,
                ),
              ),
              Positioned(
                bottom: 150.h + (20 * moveCircle.value),
                left: -40.w,
                child: CircleAvatar(
                  backgroundColor: AppColors.primiry.withOpacity(0.5),
                  radius: 40.fs,
                ),
              ),
              widget.child
            ],
          );
        });
  }
}
