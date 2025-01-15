import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/common/extensions/string_extension.dart';
import 'package:education_app/features/profil/prensentation/widgets/edit_profil_form_field_widget.dart';
import 'package:flutter/material.dart';

class EditProfilFormWidget extends StatelessWidget {
  const EditProfilFormWidget({
    required this.emailController,
    required this.fullNameController,
    required this.passwordController,
    required this.bioController,
    required this.oldPasswordController,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController passwordController;
  final TextEditingController bioController;
  final TextEditingController oldPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditProfilFormFieldWidget(
          title: 'Full name',
          controller: fullNameController,
          hintText: context.currentUser!.fullName,
        ),
        EditProfilFormFieldWidget(
          title: 'EMAIL',
          controller: emailController,
          hintText: context.currentUser!.email.obscureEmail,
        ),
        EditProfilFormFieldWidget(
          title: 'Current password',
          controller: oldPasswordController,
          hintText: '********',
        ),
        StatefulBuilder(
          builder: (_, refresh) {
            oldPasswordController.addListener(
              () => refresh(() {}),
            );
            return EditProfilFormFieldWidget(
              title: 'New password',
              controller: passwordController,
              hintText: '*******',
              readOnly: oldPasswordController.text.isEmpty,
            );
          },
        ),
        EditProfilFormFieldWidget(
          title: 'Bio',
          controller: bioController,
          hintText: context.currentUser!.bio ?? '',
        ),
      ],
    );
  }
}
