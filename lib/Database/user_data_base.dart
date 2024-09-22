import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_statemanagment/Model/user_model.dart';

Future<void> addUser(UserModel user) async {
  final userBox = await Hive.openBox<UserModel>('users');
  // Using a named key to store the user
  await userBox.put('user', user);
}


Future<UserModel?> getUser() async {
  final userBox = await Hive.openBox<UserModel>('users');
  // Fetch the user stored with the 'user' key
  return userBox.get('user');  // This could return null if no user is stored
}

