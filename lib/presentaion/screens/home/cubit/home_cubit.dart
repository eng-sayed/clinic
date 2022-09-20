import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utiles.dart';
import '../../../../data/local/sharedpreferences.dart';
import '../../../../domain/models/patient_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  List<String> sliders = [];
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future getSliders() async {
    await FirebaseFirestore.instance.collection("sliders").get().then((value) {
      value.docs.forEach((element) {
        sliders.add(element.data()['src']);
      });
      // return value.docs;
    });
  }

  Future getPatientData() async {
    await firebaseFirestore
        .collection("patient")
        .doc(Utiles.UID)
        .get()
        .then((value) {
      final user = PatientModel.fromMap(value.data()!);
      CacheHelper.saveData(key: 'user', value: jsonEncode(user));
      Utiles.image = user.image ?? '';
      Utiles.currentUser = user;
    });
  }
}
