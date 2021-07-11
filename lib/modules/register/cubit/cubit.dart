import 'package:chat_app/models/login_model.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/modules/register/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRegisterCubit extends Cubit<ChatRegisterStates> {
  ChatRegisterCubit() : super(ChatRegisterInitialState());

  static ChatRegisterCubit get(context) => BlocProvider.of(context);

  ChatLoginModel loginModel;

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String phone,
  }) {
    emit(ChatRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.toString(), password: password.toString())
        .then((value) {
      userCreate(
        email: email,
        name: name,
        phone: phone,
        uId: value.user.uid,
      );
    }).catchError((error) {
      emit(
        ChatRegisterErrorState(
          error.toString(),
        ),
      );
    });
  }

  void userCreate({
    @required String name,
    @required String email,
    @required String uId,
    @required String phone,
  }) {
    SocialUserModel user = SocialUserModel(
        userId: uId,
        userEmail: email,
        userPhone: phone,
        userName: name,
        userImage:
            "https://img.freepik.com/free-vector/flat-worker-conducts-online-meeting-virtual-team-building-videoconference-home-office_88138-508.jpg?size=626&ext=jpg",
        userBio: "Add Bio ...");

    FirebaseFirestore.instance
        .collection("user")
        .doc(uId)
        .set(
          user.toMap(),
        )
        .then((value) {
      uId = user.userId;
      emit(
        ChatCreateUserSuccessState(uId),
      );
    }).catchError((onError) {
      emit(ChatCreateUserErrorState(onError));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChatRegisterChangePasswordVisibilityState());
  }
}
