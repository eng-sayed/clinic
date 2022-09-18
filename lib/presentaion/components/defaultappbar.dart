import 'package:flutter/material.dart';

AppBar DefaultAppBar() {
  return AppBar(
    centerTitle: true,
    title: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(
            "assets/images/logowhite.png",
          ),
        )),
  );
}
