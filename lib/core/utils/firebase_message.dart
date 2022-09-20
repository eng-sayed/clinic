import 'dart:convert';

import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/data/local/sharedpreferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../domain/models/patient_model.dart';
import '../../main.dart';

class FBMessging {
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> initUniLinks() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((value) => null);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
      }
    });

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('subscribe to topic');
    await messaging.getToken().then((token) {
      print('token');
      print(token);
      CacheHelper.saveData(key: 'fcmtoken', value: token ?? '');
      Utiles.FCMToken = token!;
    });
    Utiles.UID = CacheHelper.loadData(key: 'uid') ?? '';
    // print(
    //     PatientModel.fromJson(jsonDecode(CacheHelper.loadData(key: 'user'))));
    // var x = jsonDecode(CacheHelper.loadData(key: 'user')) ?? PatientModel();
    // Utiles.currentUser = PatientModel.fromMap(x ?? Map<String, dynamic>);
  }
}
