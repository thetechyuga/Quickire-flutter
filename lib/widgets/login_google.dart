import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickhire/constants/colors.dart';

class LoginWithGoogleBox extends StatefulWidget {
  final String hint;
  final String svgIconPath;
  final bool enabled;
  final TextEditingController controller;
  final bool hasFocus;
  final bool isPassword;
  final String? errorText;
  final bool needSvg;

  const LoginWithGoogleBox({
    super.key,
    required this.hint,
    required this.svgIconPath,
    required this.enabled,
    required this.controller,
    required this.isPassword,
    required this.hasFocus,
    this.errorText,
    this.needSvg = true,
  });

  @override
  State<LoginWithGoogleBox> createState() => _LoginWithGoogleBoxState();
}

class _LoginWithGoogleBoxState extends State<LoginWithGoogleBox> {
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
        child: TextField(
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          textInputAction: TextInputAction.next,
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
                        width: 24.0,
                        height: 24.0,
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
