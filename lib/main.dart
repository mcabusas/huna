import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:huna/dashboard/dashboard.dart';
import 'package:huna/splashScreen.dart';
import 'package:huna/profile/myProfile.dart';
import 'login/login.dart';
import 'package:huna/profile/myProfileSettings.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HUNA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
        accentColor: Colors.blueGrey,
        // primarySwatch: Colors.blueGrey,
      ),
      home: SplashScreen(),
      initialRoute: '/',
      routes:{
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/second': (context) => DashboardPage(),
        '/profile': (context) => MyProfile(),
        '/profileSettingTutor': (context) => TutorProfileSettingsWidget(),
        '/profileSettingStudent': (context) => StudentProfileSettingsWidget(),
      },
    );
  }
}
