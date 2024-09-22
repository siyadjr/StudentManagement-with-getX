
import 'package:hive_flutter/hive_flutter.dart';
part 'student_model.g.dart';


@HiveType(typeId: 2)
class StudentModel {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  String age;
  
  @HiveField(2)
  String phone;
  
  @HiveField(3)
  String place;
  
  @HiveField(4)
  String? photo;

  StudentModel({
    required this.name,
    required this.age,
    required this.phone,
    required this.place,
    required this.photo,
  });
}
