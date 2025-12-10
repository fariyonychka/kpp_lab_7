import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }
    _validate();
  }

  void _validate() {
    final value = widget.controller?.text ?? '';
    final error = widget.validator?.call(value);

    setState(() => _errorText = error);
  }

  void _forceValidate() {
    if (!_hasInteracted) {
      setState(() => _hasInteracted = true);
    }
    _validate();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: widget.controller?.text,
      validator: (value) {
        final effectiveValue = widget.controller?.text ?? value;
        _forceValidate();
        return widget.validator?.call(effectiveValue);
      },
      builder: (FormFieldState<String> field) {
        final bool hasError =
            field.hasError || (_errorText != null && _hasInteracted);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border.all(
                  color: hasError ? Colors.red : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 18,
                    color: hasError ? Colors.red : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      obscureText: widget.obscureText,
                      keyboardType: widget.keyboardType,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: TextStyle(color: AppColors.placeholder),
                        border: InputBorder.none,
                        isDense: true,
                        errorStyle: const TextStyle(fontSize: 0, height: 0),
                      ),
                      onChanged: (value) {
                        field.didChange(value);
                        _onTextChanged();
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                ],
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  field.errorText ?? _errorText ?? 'Обов\'язкове поле',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 20),
            ],
          ],
        );
      },
    );
  }
}
