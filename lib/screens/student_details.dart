import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:student_statemanagment/Getx/student_controller.dart';
import 'package:student_statemanagment/Model/student_model.dart';
import 'package:student_statemanagment/screens/edit_student.dart';
import '../Constant/constant_colors.dart';

class StudentDetailsPage extends StatelessWidget {
  final StudentModel student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                student.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                ),
              ),
              background: _buildHeaderImage(),
            ),
            backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildInfoCard(),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          EditStudents(student: student)));
                            },
                            child: const Text('Edit',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 93, 74, 174)))),
                        TextButton(
                          onPressed: () {
                            final controller = Get.find<StudentController>();
                            controller.deleteStudent(student);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );

                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pop(context);
                            });
                          },
                          child: const Center(
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 174, 74, 74),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return student.photo != null
        ? Image.file(
            File(student.photo!),
            fit: BoxFit.cover,
          )
        : Image.asset(
            'lib/assets/default_student_avatar.jpeg',
            fit: BoxFit.cover,
          );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.cake, 'Age', student.age),
            const Divider(),
            _buildInfoRow(Icons.phone, 'Phone', student.phone),
            const Divider(),
            _buildInfoRow(Icons.location_on, 'Place', student.place),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon,
              color: ConstantColors.getColor(ColorOptions.mainColor), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
