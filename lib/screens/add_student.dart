import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in_up.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_down.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_left.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_statemanagment/Constant/constant_colors.dart';
import 'package:student_statemanagment/Getx/student_controller.dart';
import 'package:student_statemanagment/Model/student_model.dart';

class AddStudent extends StatelessWidget {
  AddStudent({super.key});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  final image0 = Rx<File?>(null);
  final isDefaultSelected = true.obs;

  @override
  Widget build(BuildContext context) {
    Future<void> getImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        image0.value = File(pickedFile.path);
        isDefaultSelected.value = false;
      }
    }

    void selectDefaultImage() {
      image0.value = null;
      isDefaultSelected.value = true;
    }

    void addStudentData() {
      final image = image0.value?.path;
      final student = StudentModel(
        name: nameController.text,
        age: ageController.text,
        phone: phoneController.text,
        place: placeController.text,
        photo: image,
      );
      final controller = Get.find<StudentController>();
      controller.addStudent(student);
      Navigator.pop(context);
    }

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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: _buildImagePicker(
                      image0, isDefaultSelected, getImage, selectDefaultImage),
                ),
                const SizedBox(height: 16),
                FadeInLeft(
                  child: _buildInputCard(
                    icon: Icons.person,
                    label: 'Name',
                    controller: nameController,
                  ),
                ),
                FadeInRight(
                  child: _buildInputCard(
                    icon: Icons.cake,
                    label: 'Age',
                    controller: ageController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                FadeInLeft(
                  child: _buildInputCard(
                    icon: Icons.phone,
                    label: 'Phone',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                FadeInRight(
                  child: _buildInputCard(
                    icon: Icons.place,
                    label: 'Place',
                    controller: placeController,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: BounceInUp(
                    child: _buildAddButton(addStudentData),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(
    Rx<File?> image,
    Rx<bool> isDefaultSelected,
    Function() getImage,
    Function() selectDefaultImage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImageCard(image, getImage),
        _buildDefaultImageCard(isDefaultSelected, selectDefaultImage),
      ],
    );
  }

  Widget _buildImageCard(Rx<File?> image, Function() getImage) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: getImage,
              child: Obx(() => CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        ConstantColors.getColor(ColorOptions.mainColor),
                    backgroundImage:
                        image.value != null ? FileImage(image.value!) : null,
                    child: image.value == null
                        ? const Icon(Icons.add_a_photo,
                            size: 40, color: Colors.white)
                        : null,
                  )),
            ),
            const SizedBox(height: 16),
            Text(
              image.value != null ? 'Tap to change photo' : 'Tap to add photo',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultImageCard(
      Rx<bool> isDefaultSelected, Function() selectDefaultImage) {
    return GestureDetector(
      onTap: selectDefaultImage,
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
                    backgroundImage:
                        AssetImage('lib/assets/default_student_avatar.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Default Image',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Obx(() => isDefaultSelected.value
                ? const Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 16,
                      child: Icon(Icons.check, color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
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

  Widget _buildAddButton(Function() addStudentData) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          addStudentData();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ConstantColors.getColor(ColorOptions.mainColor),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Add Student', style: TextStyle(color: Colors.white)),
    );
  }
}
