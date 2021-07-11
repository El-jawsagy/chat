import 'dart:io';

import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/models/message_group_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/modules/chats/chat.dart';
import 'package:chat_app/modules/group_chat/chat_group_massage.dart';
import 'package:chat_app/modules/settings/settings.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print("this is the error  ${error.toString()}");
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    ChatsScreen(),
    GroupChatMassageScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    'Chats',
    "Group Chat",
    'Settings',
  ];

  void changeBottomNav(int index) {
    if (index == 0) getUsers();
    if (index == 2) getUserData();

    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String image,
  }) {
    SocialUserModel model = SocialUserModel(
      userName: name,
      userPhone: phone,
      userBio: bio,
      userEmail: userModel.userEmail,
      userImage: image ?? userModel.userImage,
      userId: userModel.userId,
    );

    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel.userId)
        .update(model.toMap())
        .then((value) {
      profileImage = null;
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(SocialUserUpdateErrorState());
    });
  }

  List<SocialUserModel> users = [];

  Future<void> getUsers() async {
    users = [];
    if (users.length == 0) {
      await FirebaseFirestore.instance.collection('user').get().then((value) {
        print("this is the users ${value}");
        print("this is uid $uId");

        value.docs.forEach((element) {
          if (element.data()['uId'] != uId)
            users.add(SocialUserModel.fromJson(element.data()));
        });

        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }

  //////////////

  void sendGroupMessage({
    @required String dateTime,
    @required String text,
  }) {
    MessageChannleModel model = MessageChannleModel(
      text: text,
      senderId: uId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('groupChat')
        .doc(channelId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendGroupMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendGroupMessageErrorState());
    });

    // set receiver chats
  }

  List<MessageChannleModel> groupMessages = [];

  void getGroupMessages() {
    FirebaseFirestore.instance
        .collection('groupChat')
        .doc(channelId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      groupMessages = [];

      event.docs.forEach((element) {
        print(MessageChannleModel.fromJson(element.data()).text);
        groupMessages.add(MessageChannleModel.fromJson(element.data()));
      });

      emit(SocialGetGroupMessagesSuccessState());
    });
  }

///////////////////////////////////////

  List<SocialUserModel> usersBySearch = [];
  void getUsersBySearch({
    @required String query,
  }) {
    usersBySearch = [];
    if (usersBySearch.length == 0)
      FirebaseFirestore.instance
          .collection('user')
          .where("name", isLessThanOrEqualTo: query)
          .get()
          .then((value) {
        print("this is the users ${value}");

        value.docs.forEach((element) {
          if (element.data()['uId'] != uId)
            usersBySearch.add(SocialUserModel.fromJson(element.data()));
        });
        if (usersBySearch.length > 0) {
          emit(SocialGetAllUsersSuccessState());
        } else {
          emit(SocialGetAllUsersNotFoundState());
        }
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
  }
}
