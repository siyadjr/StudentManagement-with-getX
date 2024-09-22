import 'package:hive_flutter/hive_flutter.dart';
   part 'user_model.g.dart';
@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
 final String name;
  @HiveField(1)
 final String password;

  UserModel({required this.name, required this.password});
}
