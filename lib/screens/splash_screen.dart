import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_statemanagment/Model/user_model.dart';
import 'package:student_statemanagment/main.dart';
import 'package:student_statemanagment/screens/screen_home.dart';
import 'package:student_statemanagment/screens/screen_login.dart';
import 'package:student_statemanagment/screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      loginCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(child: Image.asset('lib/assets/Logo student .png')),
    );
  }

  Future<void> loginCheck() async {
    final sharedpref = await SharedPreferences.getInstance();
    final loggedeIn = sharedpref.getBool(userLogged);
    final signed = sharedpref.getBool(userSigned);
    final userBox = await Hive.openBox<UserModel>('users');

    if (loggedeIn != null &&
        loggedeIn == true &&
        signed == true &&
        signed != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const ScreenHome()));
    } else if (userBox.isEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const SignupScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => const ScreenLogin()));
    }
  }
}
