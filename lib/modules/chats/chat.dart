import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/models/social_model.dart';
import 'package:chat_app/modules/chat_massage/chat_massage.dart';
import 'package:chat_app/shared/components/widgets_shared.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).users.length > 0,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) => buildChatItem(
                    SocialCubit.get(context).users[index], context),
                separatorBuilder: (context, index) => Divider(),
                itemCount: SocialCubit.get(context).users.length),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        listener: (context, state) {});
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
