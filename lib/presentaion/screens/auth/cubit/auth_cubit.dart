import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/data/local/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../domain/models/patient_model.dart';
import '../../../components/alerts.dart';
import '../../../components/myLoading.dart';
import '../../../components/navigator.dart';
import '../../../layout/layout.dart';
import '../../home/home.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    print(credential.idToken);
    print(credential.token);
    print(credential);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  loginByGoogle(context) async {
    final user = await signInWithGoogle();
    print(user);

    MyLoading.show(context);
    await FirebaseFirestore.instance
        .collection('patient')
        .doc(user.user!.uid)
        .get()
        .then((documentSnapshot) async {
      if (documentSnapshot.exists) {
        Utiles.UID = user.user!.uid;
        CacheHelper.saveData(key: 'uid', value: Utiles.UID);
        final userData = PatientModel.fromMap(
            documentSnapshot.data() as Map<String, dynamic>);
        print(userData.toMap());
        CacheHelper.saveData(key: 'user', value: jsonEncode(userData));
        Utiles.currentUser = userData;

        MyLoading.dismis(context);
      } else {
        PatientModel patientModel = PatientModel(
            name: user.user!.displayName,
            id: user.user!.uid,
            fcmToken: CacheHelper.loadData(key: 'fcmtoken'),
            role: 'patient',
            phone: user.user!.phoneNumber,
            email: user.user!.email);
        await saveDataUser(user, patientModel);
        MyLoading.dismis(context);
      }
    });

    // DocumentSnapshot<Map<String, dynamic>>? response;
    // final doc = await firebaseFirestore.collection("patient").doc(Utiles.UID);
    // if(doc.)

    // try {
    //   response =
    //       await firebaseFirestore.collection("patient").doc(Utiles.UID).get();
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
    // // final response =
    // //     await firebaseFirestore.collection("patient").doc(Utiles.UID).get();

    // //print(response);
    // if (response!.data()!.isEmpty) {
    //   PatientModel patientModel = PatientModel(
    //       name: user.user!.displayName,
    //       id: user.user!.uid,
    //       fcmToken: Utiles.FCMToken,
    //       role: 'patient',
    //       phone: user.user!.phoneNumber,
    //       email: user.user!.email);
    //   await saveDataUser(user, patientModel);
    //   MyLoading.dismis(context);
    // }
    // //
    // else {
    //   Utiles.UID = user.user!.uid;
    //   CacheHelper.saveData(key: 'uid', value: Utiles.UID);
    //   final userData = PatientModel.fromMap(response.data()!);
    //   CacheHelper.saveData(key: 'user', value: jsonEncode(userData));
    //   Utiles.currentUser = userData;

    //   MyLoading.dismis(context);
    // }

    navigateReplacement(context: context, route: HomeLayout());
  }

  registerByGoogle(context) async {
    final user = await signInWithGoogle();
    PatientModel patientModel = PatientModel(
        name: user.user!.displayName,
        id: user.user!.uid,
        fcmToken: CacheHelper.loadData(key: 'fcmtoken'),
        role: 'patient',
        phone: user.user!.phoneNumber,
        email: user.user!.email);
    await saveDataUser(user, patientModel);
    navigateReplacement(context: context, route: HomeLayout());
  }

  register(PatientModel patientModel, String password, context) async {
    emit(RegisetrLoading());
    MyLoading.show(context);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: patientModel.email!.trim(), password: password);
      await saveDataUser(userCredential, patientModel);
      MyLoading.dismis(context);

      emit(RegisetrSucess());
      OverLays.snack(context,
          text: "Register Succed", state: SnakState.success);
      navigateReplacement(context: context, route: HomeLayout());

      return Future.sync(() => userCredential);
    } on FirebaseAuthException catch (e) {
      MyLoading.dismis(context);

      if (e.code == 'weak-password') {
        OverLays.snack(context, text: "weak password", state: SnakState.failed);
      } else if (e.code == 'email-already-in-use') {
        OverLays.snack(context,
            text: "email already in use", state: SnakState.failed);
      }
    }
  }

  saveDataUser(UserCredential userCredential, PatientModel patientModel) async {
    await firebaseFirestore
        .collection('patient')
        .doc(userCredential.user!.uid)
        .set(patientModel
            .copyWith(id: userCredential.user!.uid, role: 'patient')
            .toMap());
    Utiles.UID = userCredential.user!.uid;
    Utiles.currentUser = patientModel;
    CacheHelper.saveData(key: 'uid', value: Utiles.UID);
    CacheHelper.saveData(key: 'user', value: jsonEncode(patientModel));
  }

  Future login(String email, String password, context) async {
    emit(LoginLoading());
    MyLoading.show(context);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential != null) {
        Utiles.UID = userCredential.user!.uid;
        CacheHelper.saveData(key: 'uid', value: Utiles.UID);

        await firebaseFirestore
            .collection("patient")
            .doc(Utiles.UID)
            .get()
            .then((value) {
          final user = PatientModel.fromMap(value.data()!);
          CacheHelper.saveData(key: 'user', value: jsonEncode(user));
          Utiles.currentUser = user;
        });
        MyLoading.dismis(context);
        emit(Loginsucess());

        OverLays.snack(context,
            text: "Login Successed", state: SnakState.success);
        navigateReplacement(context: context, route: HomeLayout());
      }
    } on FirebaseAuthException catch (e) {
      MyLoading.dismis(context);

      if (e.code == 'user-not-found') {
        OverLays.snack(context,
            text: "User not found", state: SnakState.failed);

        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        OverLays.snack(context,
            text: "Wrong Password", state: SnakState.failed);
      }

      print('Wrong password provided for that user.');
    }
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationID = "";
  bool otpVisibility = false;
  void verifyPhone(String phone, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(minutes: 2),
      phoneNumber: '+2${phone.trim()}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
          navigateReplacement(context: context, route: HomeLayout());
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        emit(VisiabilitySuceed());
        //  setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signIn(
      context, String phone, TextEditingController otpController) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value) async {
      MyLoading.show(context);
      await FirebaseFirestore.instance
          .collection('patient')
          .doc(value.user!.uid)
          .get()
          .then((documentSnapshot) async {
        if (documentSnapshot.exists) {
          Utiles.UID = value.user!.uid;
          CacheHelper.saveData(key: 'uid', value: Utiles.UID);
          final userData = PatientModel.fromMap(
              documentSnapshot.data() as Map<String, dynamic>);
          print(userData.toMap());
          CacheHelper.saveData(key: 'user', value: jsonEncode(userData));
          Utiles.currentUser = userData;

          MyLoading.dismis(context);
        } else {
          PatientModel patientModel = PatientModel(
            name: value.user!.displayName,
            id: value.user!.uid,
            fcmToken: CacheHelper.loadData(key: 'fcmtoken'),
            role: 'patient',
            phone: phone.trim(),
          );
          await saveDataUser(value, patientModel);
          MyLoading.dismis(context);
        }
      });

      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      navigateReplacement(context: context, route: HomeLayout());
    });
  }
}
