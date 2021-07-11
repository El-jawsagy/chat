import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/models/message_group_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/shared/constant/icon_broken.dart';
import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupChatMassageScreen extends StatelessWidget {
  GroupChatMassageScreen();

  var messageController = TextEditingController();
  ScrollController listGroupMassageController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getGroupMessages();

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
            if (state is SocialGetMessagesSuccessState ||
                state is SocialSendMessageSuccessState) {
              listGroupMassageController.jumpTo(listGroupMassageController.position.maxScrollExtent);
            }
          },
          builder: (context, state) {
            return ConditionalBuilder(
              condition: state is SocialGetGroupMessagesSuccessState ||
                  state is SocialSendGroupMessageSuccessState,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: listGroupMassageController,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var message =
                              SocialCubit.get(context).groupMessages[index];
                          print(SocialCubit.get(context).groupMessages.length);

                          if (SocialCubit.get(context).userModel.userId ==
                              message.senderId) return buildMyMessage(message);

                          return buildMessage(message);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                          height: 15.0,
                        ),
                        itemCount:
                            SocialCubit.get(context).groupMessages.length,
                      ),
                    ),
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
                                SocialCubit.get(context).sendGroupMessage(
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                              },
                              minWidth: 1.0,
                              child: Icon(
                                IconBroken.Send,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageChannleModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
          ),
        ),
      );

  Widget buildMyMessage(MessageChannleModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeShared.backGround.withOpacity(
              .2,
            ),
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(
                10.0,
              ),
              topStart: Radius.circular(
                10.0,
              ),
              topEnd: Radius.circular(
                10.0,
              ),
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
          ),
        ),
      );
}
