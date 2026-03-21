import 'package:flutter/material.dart';
import '../../core/theme/app_theme_extension.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.labelSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.labelSmall.color?.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          maxLines: widget.maxLines,
          style: theme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: theme.labelSmall.copyWith(
              color: theme.labelSmall.color?.withValues(alpha: 0.4),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: theme.labelSmall.color?.withValues(alpha: 0.6),
                    ),
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: theme.surface,
            contentPadding: EdgeInsets.all(theme.spacingMD),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(theme.radiusMD),
              borderSide: BorderSide(
                color:
                    theme.labelSmall.color?.withValues(alpha: 0.1) ??
                    Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(theme.radiusMD),
              borderSide: BorderSide(
                color:
                    theme.labelSmall.color?.withValues(alpha: 0.1) ??
                    Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(theme.radiusMD),
              borderSide: BorderSide(color: theme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(theme.radiusMD),
              borderSide: BorderSide(color: theme.error),
            ),
          ),
        ),
      ],
    );
  }
}
