import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_statemanagment/Constant/constant_colors.dart';
import 'package:student_statemanagment/Database/student_data_base.dart';
import 'package:student_statemanagment/Model/student_model.dart';
import 'package:student_statemanagment/screens/add_student.dart';
import 'package:student_statemanagment/screens/screen_login.dart';
import 'package:student_statemanagment/widgets/grid_view.dart';
import 'package:student_statemanagment/widgets/list_view.dart';

enum ViewType { list, grid }

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  ViewType _currentView = ViewType.list;
  List<StudentModel> _filteredStudentList = [];
  String _searchQuery = '';
  List<StudentModel> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final value = await getAllStudents();
    if (value != null) {
      setState(() {
        students = value;
        _filteredStudentList =
            students; // Assign fetched students to filtered list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
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
                    setState(() {
                      _searchQuery = value;
                      _filteredStudentList = students
                          .where((student) => student.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<ViewType>(
                      value: _currentView,
                      onChanged: (ViewType? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _currentView = newValue;
                          });
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
                ),
              ],
            ),
          ),
          _filteredStudentList.isEmpty
              ? Center(child: Text('No students'))
              : Expanded(
                  child: _currentView == ViewType.list
                      ? StudentListView(
                          filteredStudentList: _filteredStudentList)
                      : GridViewStudents(
                          filteredStudentList: _filteredStudentList),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const AddStudent()));
        },
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> logout() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool('userlogged', false);
    await sharedPref.setBool('signed', false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const ScreenLogin()),
      (route) => false,
    );
  }
}
