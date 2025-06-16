import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/variables.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final String svgIconPath;
  final bool enabled;
  final TextEditingController controller;
  final Function(String) search;
  final FocusNode focusNode;

  const CustomSearchBar({
    super.key,
    required this.hint,
    required this.svgIconPath,
    required this.enabled,
    required this.controller,
    required this.search,
    required this.focusNode,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: TextField(
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          filled: true,
          fillColor: inputBgColor,
          hintText: hint.toString(),
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            color: secondaryText,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
            borderSide: BorderSide.none, // No border
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 8,
            ),
            child: SvgPicture.asset(
              svgIconPath,
              width: 24.0,
              height: 24.0,
              color: enabled ? notActive : null,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        onSubmitted: (value) async{
          search(value);
        },
      ),
    );
  }
}
