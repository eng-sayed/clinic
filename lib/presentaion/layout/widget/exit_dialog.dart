import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../components/customtext.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomText("closeapp".tr(), color: Colors.black),
      actions: [
        TextButton(
          child: CustomText("yes".tr(), color: AppColors.primiry),
          onPressed: () async {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: CustomText("no".tr(), color: AppColors.primiry),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
