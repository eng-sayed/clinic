import 'package:bloc/bloc.dart';
import 'package:clinic/domain/models/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/alerts.dart';
import '../../../components/myLoading.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());
  static BookingCubit get(context) => BlocProvider.of(context);

  AddingOrder(context, BookingModel bookingModel) async {
    MyLoading.show(context);
    await FirebaseFirestore.instance
        .collection('booking orders')
        .doc()
        .set(bookingModel.toMap());
    MyLoading.dismis(context);
    OverLays.snack(context,
        text: "update_profile_successed", state: SnakState.success);
    return true;
  }
}
