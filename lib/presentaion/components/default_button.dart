import 'package:clinic/core/utils/responsive.dart';
import 'package:clinic/presentaion/components/customtext.dart';

import 'package:flutter/material.dart';

import '../../../core/themes/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  double? height,
  Color background = Colors.blue,
  Color textColor = Colors.white,
  bool isUpperCase = true,
  double radius = 8.0,
  double? fontSize,
  String? fontFamily,
  required Function function,
  required String text,
}) =>
    Container(
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height ?? 60.h,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          backgroundColor: MaterialStateProperty.all(background),
        ),
        onPressed: () {
          function();
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: CustomText(
            text.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            fontsize: fontSize ?? 17.fs,
            fontFamily: fontFamily,
            color: textColor,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: AppColors.primiry,
      ),
    );
