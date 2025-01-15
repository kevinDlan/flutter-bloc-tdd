import 'package:education_app/core/common/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

class EditProfilFormFieldWidget extends StatelessWidget {
  const EditProfilFormFieldWidget({
    required this.title,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    super.key,
  });

  final String title;
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomFormField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
