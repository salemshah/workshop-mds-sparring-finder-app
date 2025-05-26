import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sparring_finder/src/config/app_routes.dart';
import 'package:sparring_finder/src/constants/app_contants.dart';
import 'package:sparring_finder/src/models/profile/profile_model.dart';
import 'package:sparring_finder/src/ui/skeletons/profile_screen_skeleton.dart';
import 'package:sparring_finder/src/ui/widgets/text_auto_scroll.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import 'package:sparring_finder/src/utils/image_res.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool isCurrentUser = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<MyProfileBloc>().add(MyProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: SafeArea(
        child: BlocBuilder<MyProfileBloc, MyProfileState>(
          builder: (context, state) {
            if (state is MyProfileLoadInProgress) {
              return const ProfileSkeleton();
            } else if (state is MyProfileFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Failed to load profile', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      onPressed: () => context.read<MyProfileBloc>().add(MyProfileRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is MyProfileLoadSuccess) {
              return _buildProfileContent(state.profile);
            }
            return const ProfileSkeleton();
          },
        ),
      ),
    );
  }

  void _updateProfilePhoto(File photo) {
    context.read<MyProfileBloc>().add(MyProfilePhotoUpdated(photo: photo));
  }


  Widget _buildProfileContent(Profile profile) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Profile Info Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
            child: Column(
              children: [
                _buildProfileImage(
                  context,
                  profile.photoUrl,
                  isCurrentUser
                ),
                SizedBox(height: 16.h),
                Container(
                  alignment: Alignment.center,
                  width: 200.w,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    child: TextAutoScroll(
                        style: TextStyle(color: AppColors.primary),
                        text: '${profile.firstName.capitalizeEachWord()} ${profile.lastName.capitalizeEachWord()}',
                        height: 30, velocity: 50),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                        Icons.location_pin,
                        size: 20,
                        color: kRed
                    ),
                    Text(
                      " ${profile.city.capitalizeEachWord()}, ${profile.country.capitalizeEachWord()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _ActionButton(
                        icon: Icons.insert_invitation_rounded,
                        backgroundColor: AppColors.inputFill,
                        iconColor: AppColors.text,
                        label: 'Availability', onPressed: () {Navigator.pushNamed(context, AppRoutes.availabilityFormScreen);}),
                    _ActionButton(
                        icon: Icons.settings,
                        iconColor: AppColors.text,
                        backgroundColor: AppColors.inputFill,
                        label: 'Setting', onPressed: () {Navigator.pushNamed(context, AppRoutes.settingsScreen);}),
                    // Expanded(child: Align(
                    //   alignment: Alignment.centerRight,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.settings_outlined,
                    //         size: 28, color: AppColors.text),
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, AppRoutes.settingsScreen);
                    //     },
                    //   ),
                    // )),
                  ],
                ),
                SizedBox(height: 10.h),
                _buildStatsRow(profile),

                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 10.h,
                  ),
                  child: Text(
                    profile.bio ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14.sp,
                      height: 1.5,
                    ),
                  ),
                ),

                _InfoRow(icon: Icons.verified, iconColor: Colors.blue, title: 'License', value: 'Verified'),
                _InfoRow(icon: Icons.signal_cellular_alt_rounded, title: 'Level', value: profile.skillLevel),
                _InfoRow(icon: Icons.cake_rounded, title: 'Age', value: '${_calculateAge(profile.dateOfBirth)} Years'),
                _InfoRow(icon: Icons.fitness_center_rounded, title: 'Weight Class', value: profile.weightClass.limit(10).capitalizeEachWord()),
                _InfoRow(icon: Icons.calendar_month_rounded, title: 'Experience', value: profile.yearsExperience.capitalizeEachWord()),
                _InfoRow(icon: Icons.interests_rounded, title: 'Styles', value: profile.preferredStyles.limit(20).capitalizeEachWord()),
                _InfoRow(icon: profile.gender == "Female" ?Icons.female_rounded :Icons.male_rounded, title: 'Gender', value: profile.gender.capitalizeEachWord()),
                _InfoRow(icon: Icons.fmd_bad_rounded, title: 'Gym', value: profile.gymName.limit(15).capitalizeEachWord()),
                _InfoRow(icon: Icons.location_city_rounded, title: 'Location', value: profile.city.limit(10).capitalizeEachWord()),
                _InfoRow(icon: Icons.flag_circle_rounded, title: 'Location', value: profile.country.limit(15).capitalizeEachWord()),
                _InfoRow(icon: Icons.link, title: 'Joined', value: '${profile.createdAt.month.toString().padLeft(2, '0')}/${profile.createdAt.year}'),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildProfileImage(BuildContext context, String? photoUrl, bool isCurrentUser) {
    return Stack(
      alignment: Alignment.center, 
      children: [
        Container(
          width: 110.w,
          height: 110.w,
          margin: EdgeInsets.only(top: 0.h, bottom: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.text, width: 3.w),
            borderRadius: BorderRadius.all(Radius.circular(60.w)),
          ),
          child: photoUrl != null && photoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: photoUrl,
                  height: 120.w,
                  width: 120.w,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: kRed),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: Colors.white30,
                    radius: 35.r,
                    child: Image.asset(ImageRes.profile),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.w)),
                      image: DecorationImage(
                        image: imageProvider, 
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Colors.white30,
                  radius: 35.r,
                  child: Image.asset(ImageRes.profile),
                ),
        ),
        Visibility(
          visible: isCurrentUser,
          child: Positioned(
            bottom: 10.w,
            right: 0.w,
            height: 35.w,
            child: GestureDetector(
              child: Container(
                height: 35.w,
                width: 35.w,
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.all(Radius.circular(40.w)),
                ),
                child: Icon(Icons.add_a_photo_rounded, color: AppColors.white, size: 20.w),
              ),
              onTap: () {
                _showPicker(context);
              }
            )
          ),
        )
      ]
    );
  }

  Widget _buildStatsRow(Profile profile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildStatItem('Weight', profile.weightClass.capitalizeEachWord(), Icons.fitness_center_rounded),
          ),
          _verticalDivider(),
          Expanded(child: _buildStatItem('Skill Level', profile.skillLevel.capitalizeEachWord(), Icons.signal_cellular_alt_rounded)),
          _verticalDivider(),
          Expanded(child:_buildStatItem('Style', profile.preferredStyles.capitalizeEachWord(), Icons.interests_rounded)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        TextAutoScroll(
          text: value,
          style: TextStyle(
            color: AppColors.text,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary),
            SizedBox(width: 2),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40.h,
      width: 1.w,
      color: AppColors.text,
    );
  }

  int _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "Change Profile Photo",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.photo_library,
                        color: Colors.blue, size: 24.sp),
                  ),
                  title: Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      fontSize: 15.sp, 
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      _updateProfilePhoto(File(image.path));
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.photo_camera,
                        color: Colors.green, size: 24.sp),
                  ),
                  title: Text(
                    'Take a Photo',
                    style: TextStyle(
                      fontSize: 15.sp, 
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      _updateProfilePhoto(File(image.path));
                    }
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  const _InfoRow({required this.title, required this.value, required this.icon, this.iconColor = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          // color: AppColors.inputFill,
          border: Border(
            bottom: BorderSide(
              color: AppColors.inputFill,
              width: 1,
            ),
          ),
          // borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 4),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text, fontSize: 12))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.text, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}


class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  const _ActionButton({required this.icon, required this.label, required this.onPressed, this.backgroundColor = AppColors.primary, this.iconColor = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: iconColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          icon: Icon(icon, size: 18),
          label: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.white)),
        ),
      ),
    );
  }
}