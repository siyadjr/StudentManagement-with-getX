import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_statemanagment/Constant/constant_colors.dart';
import 'package:student_statemanagment/Getx/student_controller.dart';
import 'package:student_statemanagment/screens/add_student.dart';
import 'package:student_statemanagment/screens/screen_login.dart';
import 'package:student_statemanagment/widgets/grid_view.dart';
import 'package:student_statemanagment/widgets/list_view.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentController studentController = Get.put(StudentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: ConstantColors.getColor(ColorOptions.mainColor),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Student',
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    studentController.searchStudents(value);
                  },
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<ViewType>(
                          value: studentController.currentView.value,
                          onChanged: (ViewType? newValue) {
                            if (newValue != null) {
                              studentController.changeView(newValue);
                            }
                          },
                          items: ViewType.values.map((ViewType type) {
                            return DropdownMenuItem<ViewType>(
                              value: type,
                              child: Row(
                                children: [
                                  Icon(
                                    type == ViewType.list
                                        ? Icons.list
                                        : Icons.grid_view,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    type == ViewType.list ? 'List' : 'Grid',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          dropdownColor:
                              ConstantColors.getColor(ColorOptions.mainColor),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.white),
                          underline: Container(),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => studentController.filteredStudents.isEmpty
                ? const Center(child: Text('No students'))
                : studentController.currentView.value == ViewType.list
                    ? StudentListView(
                        filteredStudentList: studentController.filteredStudents)
                    : GridViewStudents(
                        filteredStudentList:
                            studentController.filteredStudents)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddStudent());
        },
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool('userlogged', false);
    await sharedPref.setBool('signed', false);
    Get.offAll(() => const ScreenLogin());
  }
}
