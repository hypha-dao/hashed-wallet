import 'package:flutter/material.dart';

/// A widget wrapper of TextFormField customized for general inputs
///
class TextFormFieldLight extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;

  const TextFormFieldLight({
    super.key,
    this.controller,
    this.onChanged,
    this.maxLength,
    this.suffixIcon,
    this.hintText,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: "",
          suffixIcon: suffixIcon,
        //  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.darkGreen3)),
          hintText: hintText,
          labelText: labelText,
          contentPadding: const EdgeInsets.all(16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
         // enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.darkGreen3)),
        ),
      ),
    );
  }
}
