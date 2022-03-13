import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Intro/Intro.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:provider/provider.dart';
import './healthkatapp/current_user.dart';
import 'healthkatapp/Screens/Homepage/Homepage.dart';
import 'healthkatapp/Screens/Login/Login.dart';
import 'healthkatapp/Screens/Register/Register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HealthKatApp());
}

class HealthKatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
        child: MaterialApp(
          title: 'Health Kat',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          //0xFFFE871E
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: Intro(),
          debugShowCheckedModeBanner: false,
          routes: {

            '/Intro': (context) => Intro(),
            '/Register': (context) => Register(),
            '/Login': (context) => Login(),
            '/Homepage': (context) => Homepage(),
          }
      )
    );
  }
}
