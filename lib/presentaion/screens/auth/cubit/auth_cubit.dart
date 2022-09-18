import 'package:bloc/bloc.dart';
import 'package:clinic/core/utils/utiles.dart';
import 'package:clinic/data/local/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../domain/models/patient_model.dart';
import '../../../components/alerts.dart';
import '../../../components/myLoading.dart';
import '../../../components/navigator.dart';
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
    Utiles.UID = user.user!.uid;
    CacheHelper.saveData(key: 'uid', value: Utiles.UID);
    navigateReplacement(context: context, route: Home());
  }

  registerByGoogle(context) async {
    final user = await signInWithGoogle();
    PatientModel patientModel = PatientModel(
        name: user.user!.displayName,
        id: user.user!.uid,
        fcmToken: Utiles.FCMToken,
        role: 'patient',
        phone: user.user!.phoneNumber);
    await saveDataUser(user, patientModel);
    navigateReplacement(context: context, route: Home());
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
      navigateReplacement(context: context, route: Home());

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
    CacheHelper.saveData(key: 'uid', value: Utiles.UID);
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
        MyLoading.dismis(context);
        Utiles.UID = userCredential.user!.uid;
        CacheHelper.saveData(key: 'uid', value: Utiles.UID);
        emit(Loginsucess());
        OverLays.snack(context,
            text: "Login Successed", state: SnakState.success);
        navigateReplacement(context: context, route: Home());
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
}
