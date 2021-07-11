//core and pub package
import 'dart:math';

import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/home_layout.dart';
import 'package:chat_app/modules/login/cubit/cubit.dart';
import 'package:chat_app/modules/login/cubit/states.dart';
import 'package:chat_app/shared/components/widgets_shared.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Screen and widgets UI
import '../../shared/components/text_edit_widget.dart';
import '../../shared/components/logo_app_widget.dart';
import '../../shared/components/social_media_button_widget.dart';
import '../../shared/components/button_rounder_widget.dart';
import '../../modules/register/register.dart';

//theme and colors config
import '../../shared/themes/light_theme.dart';

class LoginModule extends StatelessWidget {
  static String routeNamed = "\login";
  LoginModule({Key key}) : super(key: key);
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatLoginCubit, ChatLoginStates>(
        builder: (ctxConsumer, state) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  LogoAppWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  TextEditWidget(
                    textEditingController: emailTextController,
                    title: "Email",
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return "this field can't be empty";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextEditWidget(
                    textEditingController: passwordTextController,
                    title: "password",
                    isPassword: true,
                    isObscure: ChatLoginCubit.get(context).isPassword,
                    suffixPressed: () {
                      ChatLoginCubit.get(context).changePasswordVisibility();
                    },
                    onValidate: (value) {
                      if (value.isEmpty) {
                        return "this field can't be empty";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ConditionalBuilder(
                    condition: state is! ChatLoginLoadingState,
                    builder: (context) => RoundedButtonWidget(
                      text: "Sign IN",
                      onButtonPress: () {
                        if (formKey.currentState.validate()) {
                          ChatLoginCubit.get(context).userLogin(
                            email: emailTextController.text,
                            password: passwordTextController.text,
                          );
                        }
                      },
                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  ConditionalBuilder(
                    condition: state is! ChatLoginFacebookLoadingState,
                    builder: (context) => SocialRoundedButtonWidget(
                      text: "facebook",
                      onButtonPress: () {
                        ChatLoginCubit.get(context).userLoginWithFaceBook();
                      },
                      backgroungColor: ThemeShared.facebookBackGround,
                    ),
                    fallback: (context) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SocialRoundedButtonWidget(
                    text: "Google",
                    backgroungColor: ThemeShared.greybackGround,
                    textColor: ThemeShared.textDarkColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SocialRoundedButtonWidget(
                    text: "Apple",
                    backgroungColor: ThemeShared.greybackGround,
                    textColor: ThemeShared.textDarkColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => Navigator.pushReplacementNamed(
                      ctxConsumer,
                      RegisterModule.routeNamed,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have acount?",
                          style: Theme.of(ctxConsumer)
                              .textTheme
                              .headline3
                              .copyWith(
                                color: ThemeShared.textDarkColor,
                              ),
                        ),
                        Text(
                          " Register",
                          style: Theme.of(ctxConsumer)
                              .textTheme
                              .headline3
                              .copyWith(
                                color: ThemeShared.textDarkColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is ChatLoginSuccessState) {
        emailTextController.clear();
        passwordTextController.clear();

        CacheHelper.saveData(
          key: 'uId',
          value: state.useruId,
        ).then((value) {
          SocialCubit.get(context).getUserData();
          SocialCubit.get(context).getGroupMessages();
          navigateAndFinish(
            context,
            HomeLayout.routeNamed,
          );
        });
        Navigator.pushReplacementNamed(context, HomeLayout.routeNamed);
      }
      if (state is ChatcreateUserAfterLoginSuccessState) {
        CacheHelper.saveData(
          key: 'uId',
          value: state.useruId,
        ).then((value) {
          uId = state.useruId;
          SocialCubit.get(context).getUserData();
          SocialCubit.get(context).getGroupMessages();
          navigateAndFinish(
            context,
            HomeLayout.routeNamed,
          );
        });
        Navigator.pushReplacementNamed(context, HomeLayout.routeNamed);
      } else if (state is ChatLoginErrorState) {
        showToast(
          text: state.error,
          state: ToastStates.ERROR,
        );
      } else if (state is ChatcreateUserAfterLoginErrorState) {
        showToast(
          text: state.error,
          state: ToastStates.ERROR,
        );
      }
    });
  }
}
