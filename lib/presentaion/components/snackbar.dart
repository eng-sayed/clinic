import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'alerts.dart';
import 'customtext.dart';

Widget SnackDesgin(SnakState state, String text) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(bottom: 100),
      child: SizedBox(
        width: 600,
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: state == SnakState.success ? Colors.green : Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                state == SnakState.success
                    ? Lottie.asset(
                        "assets/json/success.json",
                        width: 150,
                        height: 150,
                      )
                    : Lottie.asset(
                        "assets/json/error.json",
                        width: 150,
                        height: 150,
                      ),
                SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(text, textStyleEnum: TextStyleEnum.title),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
