import 'package:flutter/material.dart';
import 'package:huna/dashboard.dart';
import 'package:huna/splashScreen.dart';
import 'package:huna/secondaryPages/myProfile.dart';
import 'login.dart';
import 'package:huna/secondaryPages/myProfileSettings.dart';

void main() => runApp(MyApp());

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
