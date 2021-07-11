//core and pub package

import 'package:chat_app/layouts/home/cubit/cubit.dart';
import 'package:chat_app/modules/login/cubit/cubit.dart';
import 'package:chat_app/modules/login/login.dart';
import 'package:chat_app/modules/register/cubit/cubit.dart';
import 'package:chat_app/shared/bloc_observer.dart';
import 'package:chat_app/shared/constant/constants.dart';
import 'package:chat_app/shared/cubit/cubit.dart';
import 'package:chat_app/shared/cubit/states.dart';
import 'package:chat_app/shared/network/local/cache_helper.dart';
import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Screen and widgets UI
import 'layouts/home/home_layout.dart';

//theme and colors config
import 'modules/chat_massage/chat_massage.dart';
import 'modules/edit_profile/Edit_profile.dart';
import 'modules/register/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;
  uId = CacheHelper.getData(key: 'uId');
  if (uId != null) {
    widget = HomeLayout();
  } else {
    widget = LoginModule();
  }

  Bloc.observer = MyBlocObserver();
  runApp(MyApp(
    isDark: isDark,
    statWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget statWidget;
  MyApp({
    this.isDark,
    this.statWidget,
  });
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
            create: (context) => AppCubit()..changeAppMode(fromShared: isDark)),
        BlocProvider<ChatRegisterCubit>(
          create: (context) => ChatRegisterCubit(),
        ),
        BlocProvider<ChatLoginCubit>(
          create: (context) => ChatLoginCubit(),
        ),
        BlocProvider<SocialCubit>(
          create: (BuildContext context) => SocialCubit()
            ..getUserData()
            ..getUsers(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        builder: (BuildContext context, state) {
          return MaterialApp(
            title: 'Chat Demo',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: ThemeShared.getLightTheme(),
            home: statWidget,
            routes: {
              LoginModule.routeNamed: (ctx) => LoginModule(),
              RegisterModule.routeNamed: (ctx) => RegisterModule(),
              HomeLayout.routeNamed: (ctx) => HomeLayout(),
              EditProfileScreen.routeNamed: (ctx) => EditProfileScreen(),
              // ChatMassageScreen.routeNamed: (ctx) => ChatMassageScreen(),
            },
          );
        },
        listener: (BuildContext context, state) {},
      ),
    );
  }
}
