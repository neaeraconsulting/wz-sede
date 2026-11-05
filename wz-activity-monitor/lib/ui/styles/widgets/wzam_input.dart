import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wzam/ui/styles/screen_size.dart';

class WZAMInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? trailingTapped;
  final String? Function(String value)? validateInput;
  final bool password;
  final Rx<String?> errorMessage;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextCapitalization? textCapitalization;
  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  WZAMInputField({
    super.key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.validateInput,
    this.trailingTapped,
    this.password = false,
    Rx<String?>? errorMessage,
    this.inputFormatters,
    this.keyboardType,
    this.autofillHints,
    this.textCapitalization,
  }) : errorMessage = errorMessage ?? Rx<String?>(null);

  @override
  Widget build(BuildContext context) {
    final RxBool isPasswordVisible = false.obs;
    return SizedBox(
      width: screenWidth(context) * 0.8,
      child: Obx(() => TextField(
          controller: controller,
          style: const TextStyle(height: 1),
          obscureText: password && !isPasswordVisible.value,
          onChanged: (value) {
            errorMessage.value = validateInput?.call(value);
          },
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          decoration: InputDecoration(
            labelText: placeholder == '' ? null : placeholder,
            hintText: placeholder == '' ? null : placeholder,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            //filled: true,
            prefixIcon: leading,
            suffixIcon: password
                ? GestureDetector(
                    onTap: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                    child: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  )
                : null,
            errorText: errorMessage.value,
          ))),
    );
  }
}
