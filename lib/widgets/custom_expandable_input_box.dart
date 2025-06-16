import 'package:flutter/material.dart';
import 'package:quickhire/constants/colors.dart';

class CustomExpandableInputBox extends StatefulWidget {
  final String hint;
  final bool enabled;
  final TextEditingController controller;
  final bool hasFocus;
  final String? errorText;
  const CustomExpandableInputBox({
    super.key,
    required this.hint,
    required this.enabled,
    required this.controller,
    required this.hasFocus,
    this.errorText,
  });

  @override
  State<CustomExpandableInputBox> createState() =>
      _CustomExpandableInputBoxState();
}

class _CustomExpandableInputBoxState extends State<CustomExpandableInputBox> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _hasFocus = hasFocus;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
        ),
        child: TextFormField(
          minLines: 4,
          maxLines: 10,
          enabled: widget.enabled,
          controller: widget.controller,
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.errorText ?? '';
            }
            if (value.length < 250) {
              return '${widget.hint} can not be less than 250 words!';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBgColor,
            hintText: widget.hint.toString(),
            hintStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              color: secondaryText,
            ),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: _hasFocus
                    ? primaryColor
                    : (widget.errorText != null
                        ? Colors.red
                        : Colors.transparent),
                width: 2.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
