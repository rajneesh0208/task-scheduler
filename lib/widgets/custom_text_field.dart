import 'package:flutter/material.dart';
import 'package:taskscheduler/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? textInputType;
  final Icon? icon;
  final TextAlign? textAlign;
  final String? label;

  const CustomTextField(
      {Key? key,
      this.label,
      this.controller,
      this.hintText,
      this.icon,
      this.textAlign,
      this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8.0),
        child: TextFormField(
          controller: controller,
          textAlign: textAlign ?? TextAlign.left,

          style: const TextStyle(
            color: AppColors.white
          ),
          keyboardType: textInputType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            suffixIcon: SizedBox(
                    height: 10,
                    width: 10,
                    child: icon
                  ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
              // borderRadius: BorderRadius.circular(20)
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
              // borderRadius: BorderRadius.circular(20)
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              // borderRadius: BorderRadius.circular(100)
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              // borderRadius: BorderRadius.circular(20)
            ),
            label: Text(label ?? ""),
            labelStyle: const TextStyle(
              color: AppColors.white
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
                color: AppColors.white
            ),
          ),
        ));
  }
}
