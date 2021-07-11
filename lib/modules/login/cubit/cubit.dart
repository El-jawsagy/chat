import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/models/login_model.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class ChatLoginCubit extends Cubit<ChatLoginStates> {
  ChatLoginCubit() : super(ChatLoginInitialState());

  static ChatLoginCubit get(context) => BlocProvider.of(context);

  ChatLoginModel loginModel;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin facebookLogin = FacebookLogin();

  void userLogin({
    @required String email,
    @required String password,
  }) {
    emit(ChatLoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.toString(),
      password: password.toString(),
    )
        .then((value) {
      uId = value.user.uid;

      emit(
        ChatLoginSuccessState(value.user.uid),
      );
    }).catchError((error) {
      emit(
        ChatLoginErrorState(
          error.toString(),
        ),
      );
    });
  }

  void userLoginWithFaceBook() async {
    emit(ChatLoginFacebookLoadingState());

    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        emit(ChatLoginErrorState("cancel by user"));

        break;
      case FacebookLoginStatus.error:
        emit(ChatLoginErrorState(result.errorMessage));
        break;
      case FacebookLoginStatus.loggedIn:
        try {
          await loginWithfacebook(result);
        } catch (e) {
          emit(ChatcreateUserAfterLoginErrorState(e.toString()));
        }
        break;
    }
  }

  Future loginWithfacebook(FacebookLoginResult result) async {
    print('//////////////////////////////');
    print(result);
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
        FacebookAuthProvider.credential(accessToken.token);

    await _auth.signInWithCredential(credential).then((value) {
      print("this is user redential ${value}");
      userCreateAftersSignInSocial(
        uId: value.user.uid,
        email: value.user.email,
        name: value.user.displayName,
        phone: value.user.phoneNumber,
      );
    }).catchError((onError) {
      emit(ChatcreateUserAfterLoginErrorState(onError.toString()));
    });
  }

  void userCreateAftersSignInSocial({
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
        ChatcreateUserAfterLoginSuccessState(user.userId),
      );
    }).catchError((onError) {
      emit(ChatcreateUserAfterLoginErrorState(onError.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChatChangePasswordVisibilityState());
  }
}
