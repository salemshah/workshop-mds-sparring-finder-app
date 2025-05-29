import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sparring_finder/src/blocs/profile/profile_bloc.dart';
import 'package:sparring_finder/src/blocs/profile/profile_event.dart';
import 'package:sparring_finder/src/ui/skeletons/home/home_header_skeleton.dart';
import 'package:sparring_finder/src/ui/widgets/profile_avatar.dart';
import 'package:sparring_finder/src/utils/extensions.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../config/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/text_auto_scroll.dart';

class HomeHeader extends StatefulWidget {
  final Widget search;

  const HomeHeader({super.key, required this.search});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    context.read<MyProfileBloc>().add(const MyProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return BlocBuilder<MyProfileBloc, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileFailure) {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
          return Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top));
        } else if (state is MyProfileLoadInProgress) {
          return HomeHeaderSkeleton();
        } else if (state is MyProfileLoadSuccess) {
          // return HomeHeaderSkeleton();
          return Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(top: statusBarHeight, left: 14, right: 14),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.background],
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.text, width: 2),
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: ProfileAvatar(
                            radius: 30.r,
                            photoUrl: state.profile.photoUrl,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextAutoScroll(
                              text:
                                  state.profile.firstName.capitalizeEachWord(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            TextAutoScroll(
                              text: state.profile.lastName.capitalizeEachWord(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoutes.notificationScreen);
                          },
                          icon: const Icon(
                            Icons.notifications_active,
                            size: 35,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const Text("SPARRING FINDER",
                        style: TextStyle(
                            color: AppColors.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const Text("Find your ideal partner for sparring!",
                        style: TextStyle(color: AppColors.text, fontSize: 16)),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              widget.search
            ],
          );
        }
        return SizedBox();
      },
    );
  }
}
