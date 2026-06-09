import 'package:chating_app/app/screens/home_screen/bloc/home_bloc/home_bloc.dart';
import 'package:chating_app/app/screens/home_screen/view/home_view/profile_screen/profile_bloc/profile_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app_services/fcm_services.dart';
import 'app/core/themes/app_theme.dart';
import 'app/core/widgets/common_loader.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Initialize FCM push notifications
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FcmService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: Theme.of(context).primaryColor,
      overlayWidgetBuilder: (_) {
        //ignored progress for the moment
        return Center(child: CommonLoaderScreen());
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
          BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        ],
        child: MaterialApp(
          title: 'Chatting App',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRoutes.splashScreen, // start with login screen
        ),
      ),
    );
  }
}
