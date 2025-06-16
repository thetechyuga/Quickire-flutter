import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';

class CustomInputBox extends StatefulWidget {
  final String hint;
  final String svgIconPath;
  final bool enabled;
  final TextEditingController controller;
  final bool hasFocus;
  final bool isPassword;
  final String? errorText;
  final bool needSvg;

  const CustomInputBox({
    super.key,
    required this.hint,
    required this.svgIconPath,
    required this.enabled,
    required this.controller,
    this.isPassword = false,
    required this.hasFocus,
    this.errorText,
    this.needSvg = true,
  });

  @override
  State<CustomInputBox> createState() => _CustomInputBoxState();
}

class _CustomInputBoxState extends State<CustomInputBox> {
  bool _obscureText = true;
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
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          onTapOutside: (e) => FocusScope.of(context).unfocus(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.errorText ?? '';
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
            suffixIcon: widget.needSvg
                ? widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: widget.enabled ? notActive : null,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : SvgPicture.asset(
                        widget.svgIconPath,
                        width: 20.0,
                        height: 20.0,
                        color: widget.enabled ? notActive : null,
                        fit: BoxFit.scaleDown,
                      )
                : null,
          ),
        ),
      ),
    );
  }
}
