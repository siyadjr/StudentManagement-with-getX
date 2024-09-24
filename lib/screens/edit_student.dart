import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_statemanagment/Getx/student_controller.dart';
import 'package:student_statemanagment/Model/student_model.dart';

import '../Constant/constant_colors.dart';

class EditStudents extends StatefulWidget {
  final StudentModel student;

  const EditStudents({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentsState createState() => _EditStudentsState();
}

class _EditStudentsState extends State<EditStudents> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _placeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _ageController = TextEditingController(text: widget.student.age);
    _phoneController = TextEditingController(text: widget.student.phone);
    _placeController = TextEditingController(text: widget.student.place);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final newStudentData = StudentModel(
        name: _nameController.text,
        age: _ageController.text,
        phone: _phoneController.text,
        place: _placeController.text,
        photo: widget.student.photo,
      );
      final controller = Get.find<StudentController>();
      controller.updateStudent(newStudentData, widget.student).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 385,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Edit ${widget.student.name}',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildEditCard(),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              ConstantColors.getColor(ColorOptions.mainColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Save Changes',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return widget.student.photo != null
        ? Image.file(
            File(widget.student.photo!),
            fit: BoxFit.cover,
          )
        : Image.asset(
            'lib/assets/default_student_avatar.jpeg',
            fit: BoxFit.cover,
          );
  }

  Widget _buildEditCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(Icons.person, 'Name', _nameController),
            _buildTextField(
                Icons.cake, 'Age', _ageController, TextInputType.number),
            _buildTextField(
                Icons.phone, 'Phone', _phoneController, TextInputType.phone),
            _buildTextField(Icons.location_on, 'Place', _placeController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon,
              color: ConstantColors.getColor(ColorOptions.mainColor)),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: ConstantColors.getColor(ColorOptions.mainColor),
                width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
