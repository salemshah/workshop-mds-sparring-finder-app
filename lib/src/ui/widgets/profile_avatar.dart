import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    this.radius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius.r,
      backgroundColor: AppColors.inputFill,
      backgroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
      child: !hasPhoto
          ? Icon(
        Icons.person_2_rounded,
        size: radius.r,
        color: Colors.grey,
      )
          : null,
    );
  }
}
