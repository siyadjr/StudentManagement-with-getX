import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in_up.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_down.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_left.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_statemanagment/Constant/constant_colors.dart';
import 'package:student_statemanagment/Database/student_data_base.dart';
import 'package:student_statemanagment/Model/student_model.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _placeController = TextEditingController();
  File? _image;
  bool _isDefaultSelected = true;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isDefaultSelected = false; // Reset if a new image is selected
      }
    });
  }

  void _selectDefaultImage() {
    setState(() {
      _image = null;
      _isDefaultSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Add New Student'),
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _getImage,
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundColor: ConstantColors.getColor(
                                      ColorOptions.mainColor),
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : null,
                                  child: _image == null
                                      ? const Icon(Icons.add_a_photo,
                                          size: 40, color: Colors.white)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _image != null
                                    ? 'Tap to change photo'
                                    : 'Tap to add photo',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectDefaultImage,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.teal,
                                        backgroundImage: AssetImage(
                                            'lib/assets/default_student_avatar.jpeg')),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Default Image',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              if (_isDefaultSelected)
                                const Positioned(
                                  top: 8,
                                  right: 8,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 16,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FadeInLeft(
                  child: _buildInputCard(
                    icon: Icons.person,
                    label: 'Name',
                    controller: _nameController,
                  ),
                ),
                FadeInRight(
                  child: _buildInputCard(
                    icon: Icons.cake,
                    label: 'Age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                FadeInLeft(
                  child: _buildInputCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                FadeInRight(
                  child: _buildInputCard(
                    icon: Icons.place,
                    label: 'Place',
                    controller: _placeController,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: BounceInUp(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addStudentData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            ConstantColors.getColor(ColorOptions.mainColor),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add Student',
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            icon: Icon(
              icon,
              color: ConstantColors.getColor(ColorOptions.mainColor),
            ),
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (label == 'Age' && int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
    );
  }

  Future<void> addStudentData() async {
    final image = _image?.path;
    final student = StudentModel(
        name: _nameController.text,
        age: _ageController.text,
        phone: _phoneController.text,
        place: _placeController.text,
        photo: image);
    await addStudent(student);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _placeController.dispose();
    super.dispose();
  }
}
