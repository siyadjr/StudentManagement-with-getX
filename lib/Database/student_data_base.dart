import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_statemanagment/Model/student_model.dart';

Future<void> addStudent(StudentModel student) async {
  final studentBox = Hive.box<StudentModel>('students');
  await studentBox.add(student);
}

Future<List<StudentModel>?> getAllStudents() async {
  final studentBox = Hive.box<StudentModel>('students');
  return studentBox.values.toList();
}

Future<void> deleteStudent(StudentModel student) async {
  final studentBox = Hive.box<StudentModel>('students');
  int index = studentBox.values
      .toList()
      .indexWhere((students) => students.name == student.name);
  studentBox.deleteAt(index);
}
