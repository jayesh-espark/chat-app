import 'package:chating_app/app/core/widgets/exit_dialog.dart';
import 'package:chating_app/app/screens/auth_screens/bloc/auth_bloc.dart';
import 'package:chating_app/app/screens/home_screen/view/home_view/current_chat_list/current_chats_bloc/current_chats_bloc.dart';

import 'package:chating_app/app/screens/home_screen/view/home_view/home_view.dart';
import 'package:chating_app/app/screens/home_screen/view/home_view/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/auth_screens/view/login_view.dart';
import '../screens/auth_screens/view/signup_view.dart';
import '../screens/home_screen/view/home_view/chat_room/chat_room_bloc/chat_room_bloc.dart';
import '../screens/home_screen/view/home_view/chat_room/chat_room_view/chat_room_view.dart';
import '../screens/home_screen/view/home_view/new_chat/new_chat_bloc/new_chat_bloc.dart';
import '../screens/home_screen/view/home_view/new_chat/new_chat_view/add_new_chat_view.dart';
import '../screens/splash_screen/bloc/splash/splash_bloc.dart';
import '../screens/splash_screen/view/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  // Named routes

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => SplashBloc(),
            child: SplashView(),
          ),
        );
      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CurrentChatsBloc>(
                create: (context) => CurrentChatsBloc(),
              ),
              BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
            ],
            child: HomeView(),
          ),
        );
      case AppRoutes.addNewChat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => NewChatBloc(),
            child: AddNewChatView(),
          ),
        );
      case AppRoutes.chatBubbleScreen:
        return MaterialPageRoute(
          settings: RouteSettings(
            name: AppRoutes.chatBubbleScreen,
            arguments: settings.arguments,
          ),
          builder: (_) => BlocProvider(
            create: (context) => ChatRoomBloc(),
            child: ChatRoomView(),
          ),
        );
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider(create: (context) => AuthBloc(), child: LoginView()),
        );
      case AppRoutes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(),
            child: SignUpView(),
          ),
        );
      default:
        // If route not found, show a 404 page
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      return LogOutDialog();
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('No route defined for ${settings.name}'),
                    Text("404"),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
