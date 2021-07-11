abstract class ChatLoginStates {}

class ChatLoginInitialState extends ChatLoginStates {}

class ChatLoginLoadingState extends ChatLoginStates {}

class ChatLoginFacebookLoadingState extends ChatLoginStates {}

class ChatLoginSuccessState extends ChatLoginStates {
  final String useruId;

  ChatLoginSuccessState(this.useruId);
}

class ChatcreateUserAfterLoginSuccessState extends ChatLoginStates {
  final String useruId;

  ChatcreateUserAfterLoginSuccessState(this.useruId);
}

class ChatcreateUserAfterLoginErrorState extends ChatLoginStates {
  final String error;

  ChatcreateUserAfterLoginErrorState(this.error);
}

class ChatLoginErrorState extends ChatLoginStates {
  final String error;

  ChatLoginErrorState(this.error);
}

class ChatChangePasswordVisibilityState extends ChatLoginStates {}
