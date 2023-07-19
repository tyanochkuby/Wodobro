import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WodobroTextFormField extends StatelessWidget {
  const WodobroTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.validator,
    this.onChanged,
    this.label,
    this.enabled,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? label;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;

  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled != null ? enabled : true,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        label: label != null ? Text(label!) : null,
      ),
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}


class WodobroTextField extends StatelessWidget{
  const WodobroTextField({
    super.key,
    required this.controller,
    this.hintText,
    required this.keyboardType,
    this.validator,
    this.onChanged,
    this.label,
    this.enabled,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? label;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType keyboardType;

  Widget build(BuildContext context){
    return TextField(
      enabled: enabled != null ? enabled : true,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        label: label != null ? Text(label!) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,

    );
  }
}
