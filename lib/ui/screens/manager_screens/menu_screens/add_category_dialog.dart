import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/services/image_service.dart';
import 'package:splitz/data/services/menu_category_service.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';
import 'package:toastification/toastification.dart';

class AddCategoryDialog extends StatefulWidget {
  final String restaurantId;
  final Function(MenuCategory) onCategoryAdded;

  AddCategoryDialog(
      {required this.restaurantId, required this.onCategoryAdded});

  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  String categoryName = '';
  String description = '';
  File? _image; // To hold the image file

  final CategoryService _categoryService = CategoryService();

  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Submit the form
  void _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      String? imageUrl = await uploadFile(_image!);

      if (imageUrl != null) {
        MenuCategory newCategory = MenuCategory(
          name: categoryName,
          description: description,
          image: imageUrl,
          itemIds: [],
        );

        widget.onCategoryAdded(newCategory);
        Navigator.pop(context);
        toastification.show(
          context: context,
          title: Text('Menu Category Is Added Successfuly!'),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
          alignment: Alignment.topRight,
          direction: TextDirection.ltr,
          animationDuration: const Duration(milliseconds: 300),
          icon: const Icon(Icons.check),
          showIcon: true, // show or hide the icon
          primaryColor: Colors.green,
        );
      }
    } else {
      toastification.show(
        context: context,
        title: Text('ERROr please add an image!'),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.error),
        showIcon: true,
        primaryColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.textColor,
      content: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Category',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center the title
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Offer delicious new categories and make your restaurant the go-to place for food lovers!🚀',
                    style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: AppColors.background),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Category Name',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: AppColors.textColor,
                    ),
                    textAlign: TextAlign.center, // Center the text
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category name';
                      }
                      return null;
                    },
                    onChanged: (value) => categoryName = value,
                  ),
                  SizedBox(height: 16),

                  // Description
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        fontSize: 18,
                      ),
                      filled: true,
                      fillColor: AppColors.textColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textAlign: TextAlign.center, // Center the text
                    maxLines: 4, // Increase the height of the description field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onChanged: (value) => description = value,
                  ),
                  SizedBox(height: 16),

                  // Image Upload
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                          color: AppColors.textColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black)),
                      child: _image == null
                          ? Center(
                              child: Icon(Icons.camera_alt, size: 50),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 40),

                  CustomElevatedButton(
                    text: "Add Category",
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
