import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Model/student_model.dart';
import '../Database/student_data_base.dart';

class StudentController extends GetxController {
  var students = <StudentModel>[].obs;
  var filteredStudents = <StudentModel>[].obs;
  var searchQuery = ''.obs;
  var currentView = ViewType.list.obs;

  @override
  void onInit() {
    super.onInit();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final value = await getAllStudents();
    if (value != null) {
      students.value = value;
      filteredStudents.value = value;
    }
  }

  Future<void> updateStudent(
      StudentModel newstudent, StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    final index =
        studentBox.values.toList().indexWhere((s) => s.name == student.name);
    studentBox.putAt(index, newstudent);

    loadStudents();
  }

  Future<void> deleteStudent(StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    final index =
        studentBox.values.toList().indexWhere((s) => s.name == student.name);
    studentBox.deleteAt(index);

    loadStudents();
  }

  Future<void> addStudent(StudentModel student) async {
    final studentBox = Hive.box<StudentModel>('students');
    await studentBox.add(student);
    loadStudents();
  }

  void searchStudents(String query) {
    searchQuery.value = query;
    filteredStudents.value = students.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void changeView(ViewType newView) {
    currentView.value = newView;
  }
}

enum ViewType { list, grid }
