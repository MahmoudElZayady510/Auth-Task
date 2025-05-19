
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'back_arrow.dart';

class customAppBar extends StatelessWidget {
  final  String title;
  const customAppBar({
    super.key, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.w,child: BackArrow()),
        Expanded(
          child: Center(
            child: Text(title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        SizedBox(width: 50.w,)
      ],
    );
  }
}