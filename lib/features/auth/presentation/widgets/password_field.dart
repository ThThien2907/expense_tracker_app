import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.passwordController,
    required this.focusNode,
  });

  final TextEditingController passwordController;
  final FocusNode focusNode;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isHidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.passwordController,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.password,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: isHidePassword
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isHidePassword = !isHidePassword;
                });
              },
              color: AppColors.light20,
              // padding: EdgeInsets.only(right: 16),
            ),
          )),
      obscureText: isHidePassword,
    );
  }
}
