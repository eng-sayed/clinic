import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/domain/models/patient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

import '../../../../data/local/sharedpreferences.dart';
import '../../../components/alerts.dart';
import '../../../components/myLoading.dart';
import '../../../components/navigator.dart';
import '../../auth/screens/sign_up.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);

  File? pickedImage;
  String? imageUrl;
  picedImage(context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    pickedImage = File(image!.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    MyLoading.show(context);
    try {
      if (Utiles.currentUser.image != null) {
        await firebase_storage.FirebaseStorage.instance
            .refFromURL(Utiles.currentUser.image!)
            .delete();
      }
      firebase_storage.TaskSnapshot storageTaskSnapshot = await firebase_storage
          .FirebaseStorage.instance
          .ref(fileName)
          .putFile(pickedImage!);
      imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('patient')
          .doc(Utiles.UID)
          .update({
        'image': imageUrl,
      });

      Utiles.currentUser = Utiles.currentUser.copyWith(image: imageUrl);
      Utiles.image = Utiles.currentUser.image!;
      CacheHelper.saveData(key: 'user', value: jsonEncode(Utiles.currentUser));
      emit(ImageSuccsed());

      print(jsonDecode(CacheHelper.loadData(key: 'user')));

      MyLoading.dismis(context);
      OverLays.snack(context,
          text: "update_profile_successed", state: SnakState.success);
    } on firebase_core.FirebaseException catch (e) {
      MyLoading.dismis(context);

      OverLays.snack(context,
          text: "update_profile_failed", state: SnakState.failed);
      print(e);
    }
  }

  updateUserData(PatientModel patientModel, context) async {
    MyLoading.show(context);

    await FirebaseFirestore.instance
        .collection('patient')
        .doc(Utiles.UID)
        .update(patientModel.toMap());
    await FirebaseFirestore.instance
        .collection("patient")
        .doc(Utiles.UID)
        .get()
        .then((value) {
      final user = PatientModel.fromMap(value.data()!);
      CacheHelper.saveData(key: 'user', value: jsonEncode(user));
      Utiles.currentUser = user;
    });
    MyLoading.dismis(context);
    OverLays.snack(context,
        text: "update_profile_successed", state: SnakState.success);
  }

  logout(context) async {
    await FirebaseAuth.instance.signOut();
    CacheHelper.resetShared();
    navigateReplacement(context: context, route: SignUpPage());
  }
}
