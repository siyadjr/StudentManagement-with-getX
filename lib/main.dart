import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_statemanagment/Model/student_model.dart';
import 'package:student_statemanagment/Model/user_model.dart';

import 'package:student_statemanagment/screens/splash_screen.dart';

const userLogged = 'userlogged';
const userSigned = 'signed';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(StudentModelAdapter());
  await Hive.openBox<UserModel>('users');
  await Hive.openBox<StudentModel>('students');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Student Management',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
