import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:student_statemanagment/Constant/constant_colors.dart';

import 'package:student_statemanagment/Getx/student_controller.dart';
import 'package:student_statemanagment/Model/student_model.dart';
import 'package:student_statemanagment/screens/edit_student.dart';
import 'package:student_statemanagment/screens/student_details.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({
    super.key,
    required List<StudentModel> filteredStudentList,
  }) : _filteredStudentList = filteredStudentList;

  final List<StudentModel> _filteredStudentList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _filteredStudentList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => StudentDetailsPage(
                          student: _filteredStudentList[index])));
            },
            title: Text(_filteredStudentList[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            leading: CircleAvatar(
              backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
              child: Text(_filteredStudentList[index].name[0],
                  style: const TextStyle(color: Colors.white)),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                      context,
                      (MaterialPageRoute(
                          builder: (ctx) => EditStudents(
                              student: _filteredStudentList[index]))));
                } else if (value == 'delete') {
                  final controller = Get.find<StudentController>();
                  controller.deleteStudent(_filteredStudentList[index]);
                  controller.loadStudents();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
