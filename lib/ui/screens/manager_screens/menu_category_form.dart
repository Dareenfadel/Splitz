import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:splitz/constants/app_colors.dart';
import 'package:splitz/data/models/menu_category.dart';
import 'package:splitz/data/services/image_service.dart';
import 'package:splitz/data/services/menu_category_service.dart';
import 'package:splitz/ui/custom_widgets/custom_button.dart';

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
        // Add category with image URL
        await _categoryService.addMenuCategory(
          widget.restaurantId,
          categoryName,
          description,
          imageUrl, // Use the Firebase image URL
        );

        MenuCategory newCategory = MenuCategory(
          name: categoryName,
          description: description,
          image: imageUrl,
          itemIds: [],
        );

        widget.onCategoryAdded(newCategory);

        // Show success dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          title: 'Category Added',
          desc: 'Do you want to add items to this category?',
          btnOkText: "Yes",
          btnCancelText: "No",
          btnOkOnPress: () {
            // You can add additional logic when 'Yes' is pressed
          },
          btnCancelOnPress: () {
            Navigator.pop(context); // Close the dialog
          },
        ).show();
      } else {
        // Show a message if no image is selected
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Please select an image for the category.',
          btnOkText: "OK",
          btnOkOnPress: () {},
        ).show();
      }
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
