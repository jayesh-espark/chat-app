import 'package:chating_app/app/screens/home_screen/bloc/home_bloc/home_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/core/themes/app_theme.dart';
import 'app/core/utills/common_functions.dart';
import 'app/core/widgets/common_loader.dart';
import 'app/router/app_router.dart';
import 'app/router/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  var supaBaseCred = await getSupBaseCred();
  var SUPABASE_URL = supaBaseCred['url'] ?? "";
  var SUPABASE_ANON_KEY = supaBaseCred['anonKey'] ?? "";
  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

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
        providers: [BlocProvider<HomeBloc>(create: (context) => HomeBloc())],
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
