import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/shared/components/default_button_widget.dart';
import 'package:chat_app/shared/components/text_edit_widget.dart';
import 'package:chat_app/shared/constant/icon_broken.dart';
import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  static String routeNamed = "\edit_profile";

  const EditProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameTextController = TextEditingController();
    var phoneTextController = TextEditingController();
    var bioTextController = TextEditingController();

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var profileImage = SocialCubit.get(context).profileImage;
        nameTextController.text = userModel.userName;
        phoneTextController.text = userModel.userPhone;
        bioTextController.text = userModel.userBio;
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Profile"),
            actions: [
              if (SocialCubit.get(context).profileImage == null)
                DefaultTextButton(
                  function: () {
                    SocialCubit.get(context).updateUser(
                      name: nameTextController.text,
                      phone: phoneTextController.text,
                      bio: bioTextController.text,
                    );
                  },
                  text: 'Update',
                ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  SizedBox(
                    height: 40,
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 64.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: profileImage == null
                              ? NetworkImage(
                                  '${userModel.userImage}',
                                )
                              : FileImage(profileImage),
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundColor: ThemeShared.primary,
                          radius: 20.0,
                          child: Icon(
                            IconBroken.Camera,
                            size: 16.0,
                          ),
                        ),
                        onPressed: () {
                          SocialCubit.get(context).getProfileImage();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (SocialCubit.get(context).profileImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                DefaultTextButton(
                                  function: () {
                                    SocialCubit.get(context).uploadProfileImage(
                                      name: nameTextController.text,
                                      phone: phoneTextController.text,
                                      bio: bioTextController.text,
                                    );
                                  },
                                  textColor: ThemeShared.primary,
                                  text: 'upload profile',
                                ),
                                if (state is SocialUserUpdateLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateLoadingState)
                                  LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  TextEditWidget(
                    textEditingController: nameTextController,
                    type: TextInputType.name,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return 'name must not be empty';
                      }

                      return null;
                    },
                    title: 'Name',
                    prefixIcon: IconBroken.User,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextEditWidget(
                    textEditingController: bioTextController,
                    type: TextInputType.text,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return 'Bio must not be empty';
                      }

                      return null;
                    },
                    title: 'Bio',
                    prefixIcon: IconBroken.User,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextEditWidget(
                    textEditingController: phoneTextController,
                    type: TextInputType.phone,
                    onValidate: (String value) {
                      if (value.isEmpty) {
                        return 'phone must not be empty';
                      }

                      return null;
                    },
                    title: 'phone',
                    prefixIcon: IconBroken.User,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
