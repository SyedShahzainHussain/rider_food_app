import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? icon;
  final String? hintText;
  bool? enabled = true;
  bool? isObsecure = true;
  Widget? suffixIcon;
  final String? Function(String?)? validator;
  Function(String)? onFieldSubmitted;
  FocusNode? focusNode;
  TextInputAction? textInputAction;
  TextInputType? keyboardType;
  CustomTextField({
    super.key,
    this.controller,
    this.icon,
    this.hintText,
    this.enabled,
    this.isObsecure,
    this.validator,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        enabled: enabled,
        controller: controller,
        obscureText: isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              color: Colors.cyan,
            ),
            focusColor: Theme.of(context).primaryColor,
            hintText: hintText),
      ),
    );
  }
}
