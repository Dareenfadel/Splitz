import 'package:flutter/material.dart';
import 'package:splitz/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool isNumber; // Optional: For numeric input

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.isNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: const Color.fromARGB(148, 0, 0, 0)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondary, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: validator,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }
}
