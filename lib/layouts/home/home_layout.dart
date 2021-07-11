import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/layouts/home/cubit/states.dart';
import 'package:chat_app/modules/login/login.dart';
import 'package:chat_app/modules/search/search.dart';
import 'package:chat_app/shared/components/widgets_shared.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:chat_app/shared/constant/icon_broken.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  static String routeNamed = "\homePage";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            leading: IconButton(
              icon: Icon(
                IconBroken.Logout,
              ),
              onPressed: () {
                uId = null;
                cubit.userModel = null;
                cubit.changeBottomNav(0);
                CacheHelper.removeData(key: "uId").then(
                  (value) => value
                      ? navigateAndFinish(context, LoginModule.routeNamed)
                      : null,
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  IconBroken.Search,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => SearchScreen()));
                },
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.User1,
                ),
                label: 'group chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
