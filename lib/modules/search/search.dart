import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/modules/chat_massage/chat_massage.dart';
import 'package:chat_app/shared/components/widgets_shared.dart';
import 'package:chat_app/shared/constant/icon_broken.dart';
import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key key}) : super(key: key);
  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state is SocialGetAllUsersSuccessState,
              builder: (context) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300],
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'type your message here ...',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          color: ThemeShared.backGround,
                          child: MaterialButton(
                            onPressed: () {
                              SocialCubit.get(context).getUsersBySearch(
                                  query: messageController.text);
                            },
                            minWidth: 1.0,
                            child: Icon(
                              IconBroken.Search,
                              size: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) => buildChatItem(
                            SocialCubit.get(context).users[index], context),
                        separatorBuilder: (context, index) => Divider(),
                        itemCount:
                            SocialCubit.get(context).usersBySearch.length),
                  ),
                ],
              ),
              fallback: (context) => (SocialCubit.get(context)
                              .usersBySearch
                              .length ==
                          0 ||
                      state is SocialGetAllUsersNotFoundState)
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here ...',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 50.0,
                                  color: ThemeShared.backGround,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getUsersBySearch(
                                          query: messageController.text);
                                    },
                                    minWidth: 1.0,
                                    child: Icon(
                                      IconBroken.Search,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Center(
                          child: Text("No User To Display"),
                        ))
                      ],
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300],
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: TextFormField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'type your message here ...',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 50.0,
                                  color: ThemeShared.backGround,
                                  child: MaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).getUsersBySearch(
                                          query: messageController.text);
                                    },
                                    minWidth: 1.0,
                                    child: Icon(
                                      IconBroken.Search,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Center(
                          child: CircularProgressIndicator(),
                        ))
                      ],
                    ),
            );
          },
          listener: (context, state) {}),
    );
  }

  Widget buildChatItem(SocialUserModel user, context) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => ChatMassageScreen(
                  userModel: user,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  user.userImage,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Text(
                user.userName,
                style: TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
