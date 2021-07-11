import 'package:chat_app/models/login_model.dart';

abstract class ChatRegisterStates {}

class ChatRegisterInitialState extends ChatRegisterStates {}

class ChatRegisterLoadingState extends ChatRegisterStates {}

class ChatRegisterSuccessState extends ChatRegisterStates {
//   final ChatLoginModel loginModel;

//   ChatRegisterSuccessState(this.loginModel);
}

class ChatRegisterErrorState extends ChatRegisterStates {
  final String error;

  ChatRegisterErrorState(this.error);
}

class ChatCreateUserSuccessState extends ChatRegisterStates {
  final String useruId;

  ChatCreateUserSuccessState(this.useruId);
}

class ChatCreateUserErrorState extends ChatRegisterStates {
  final String error;

  ChatCreateUserErrorState(this.error);
}

class ChatRegisterChangePasswordVisibilityState extends ChatRegisterStates {}
