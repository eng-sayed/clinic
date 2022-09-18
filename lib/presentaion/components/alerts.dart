import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'alert_dialog.dart';
import 'snackbar.dart';

enum SnakState { success, failed }

class OverLays {
  static Future dialog(BuildContext context,
      {required Widget child,
      RouteSettings? routeSettings,
      EdgeInsets? insetPadding,
      AlignmentGeometry? alignment,
      Color? backgroundColor}) {
    return showDialog(
        context: context,
        routeSettings: routeSettings,
        builder: (context) => Dialog(
              backgroundColor: backgroundColor,
              insetPadding: insetPadding,
              alignment: alignment,
              child: child,
            ));
  }

  static Future yesOrNoDialog(BuildContext context,
      {required String title,
      required String action1title,
      required String action2title,
      required Function action1,
      required Function action2,
      Widget? icon,
      RouteSettings? routeSettings,
      EdgeInsets? insetPadding,
      AlignmentGeometry? alignment,
      Color? backgroundColor}) {
    return showDialog(
        context: context,
        routeSettings: routeSettings,
        builder: (context) => alertDialog(backgroundColor, alignment, icon,
            title, action1, action1title, action2, action2title));
  }

  static Future bottomSheet(BuildContext context,
      {required Widget child,
      RouteSettings? routeSettings,
      EdgeInsets? insetPadding,
      AlignmentGeometry? alignment,
      Color? backgroundColor}) {
    return showModalBottomSheet(
        routeSettings: routeSettings,
        clipBehavior: Clip.hardEdge,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
        ),
        context: context,
        builder: (context) => child);
  }

  static snack(BuildContext context,
      {required String text, required SnakState state}) {
    BotToast.showCustomText(
        align: Alignment.center,
        onlyOne: true,
        toastBuilder: (s) => SnackDesgin(state, text));
  }
}
