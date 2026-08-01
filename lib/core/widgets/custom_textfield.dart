import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hint;
  final String? label;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.hint,
    this.label,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.label != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.label!,
                    style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                  ),
                ],
                TextField(
                  controller: widget.controller,
                  obscureText: widget.isPassword ? _obscure : false,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            )
          else if (widget.suffix != null)
            widget.suffix!,
        ],
      ),
    );
  }
}