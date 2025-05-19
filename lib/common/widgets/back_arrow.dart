import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/configs/theme/app_colors.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator.canPop(context) ? FloatingActionButton(
      mini: true,
      elevation: 0,
      // backgroundColor: AppColors.secondBackgroundColor,
        backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.secondaryColor,
          border: Border.all(color: AppColors.grey, width: 1.r)
        ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Icon(Icons.arrow_back_ios_sharp , color: Colors.black, size: 20.r,),
          )
      ),
        onPressed: (){
          Navigator.of(context).pop();
        }) : SizedBox();
  }
}
