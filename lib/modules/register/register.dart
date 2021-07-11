//core and pub package
import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/home_layout.dart';
import 'package:chat_app/modules/register/cubit/cubit.dart';
import 'package:chat_app/modules/register/cubit/states.dart';
import 'package:chat_app/shared/components/widgets_shared.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Screen and widgets UI
import '../../modules/login/login.dart';
import '../../shared/components/text_edit_widget.dart';
import '../../shared/components/logo_app_widget.dart';
import '../../shared/components/button_rounder_widget.dart';

class RegisterModule extends StatelessWidget {
  static String routeNamed = "\register";

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatRegisterCubit, ChatRegisterStates>(
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
                    height: 40,
                  ),
                    LogoAppWidget(),
                    SizedBox(
                    height: 40,
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
                    height: 40,
                  ),
                    TextEditWidget(
                      textEditingController: nameTextController,
                      title: "Name",
                      type: TextInputType.name,
                      prefixIcon: Icons.person,
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "this field can't be empty";
                        }
                      },
                    ),
                    SizedBox(
                    height: 40,
                  ),
                    TextEditWidget(
                      textEditingController: phoneTextController,
                      title: "Phone",
                      type: TextInputType.phone,
                      prefixIcon: Icons.phone,
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "this field can't be empty";
                        }
                      },
                    ),
                    SizedBox(
                    height: 40,
                  ),
                    TextEditWidget(
                      textEditingController: passwordTextController,
                      title: "password",
                      isPassword: true,
                      isObscure: ChatRegisterCubit.get(context).isPassword,
                      prefixIcon: Icons.east,
                      suffixPressed: () {
                        ChatRegisterCubit.get(context).changePasswordVisibility();
                      },
                      onValidate: (value) {
                        if (value.isEmpty) {
                          return "this field can't be empty";
                        }
                      },
                    ),
                    SizedBox(
                    height: 40,
                  ),
                    ConditionalBuilder(
                      condition: state is! ChatRegisterLoadingState,
                      builder: (context) => RoundedButtonWidget(
                        text: "Sign Up",
                        onButtonPress: () {
                          if (formKey.currentState.validate()) {
                            ChatRegisterCubit.get(context).userRegister(
                              name: nameTextController.text,
                              email: emailTextController.text,
                              password: passwordTextController.text,
                              phone: phoneTextController.text,
                            );
                          }
                        },
                      ),
                      fallback: (context) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                    SizedBox(
                    height: 40,
                  ),
                    InkWell(
                      onTap: () => Navigator.pushReplacementNamed(
                        ctxConsumer,
                        LoginModule.routeNamed,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "already have acount?",
                            style: Theme.of(ctxConsumer)
                                .textTheme
                                .headline3
                                .copyWith(
                                  color: ThemeShared.textDarkColor,
                                ),
                          ),
                          Text(
                            " LOGIN",
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
                    height: 40,
                  ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is ChatCreateUserSuccessState) {
          emailTextController.clear();
          nameTextController.clear();
          passwordTextController.clear();
          phoneTextController.clear();
          CacheHelper.saveData(
            key: 'uId',
            value: state.useruId,
          ).then((value) {
            uId = state.useruId;
            SocialCubit.get(context).getUsers();
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getGroupMessages();
            navigateAndFinish(
              context,
              HomeLayout.routeNamed,
            );
          });
        } else if (state is ChatRegisterErrorState) {
          showToast(
            text: state.error,
            state: ToastStates.ERROR,
          );
        }
      },
    );
  }
}
