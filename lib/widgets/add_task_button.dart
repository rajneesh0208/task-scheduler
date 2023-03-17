import 'package:flutter/material.dart';
import 'package:taskscheduler/constants/app_colors.dart';

class AddTaskButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final double? width;

  const AddTaskButton({Key? key,this.width,required this.onTap,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.white ,
      highlightColor: AppColors.white,
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 50,
        width: width ?? MediaQuery.of(context).size.width * .85,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:2.0,left: 8,right: 8.0),
          child: Center(
            child: Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.purpleBackground,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
