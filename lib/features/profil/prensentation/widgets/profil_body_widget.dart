import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:education_app/features/profil/prensentation/widgets/user_info_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfilBodyWidget extends StatelessWidget {
  const ProfilBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserInfoCardWidget(
                  infoThemeColor: AppPallete.physicsTileColour,
                  infoIcon: const Icon(
                    IconlyLight.document,
                    size: 24,
                    color: Color(0xFF767DFF),
                  ),
                  infoTitle: 'Courses',
                  infoValue: user!.enrolledCourseIds.length.toString(),
                ),
                UserInfoCardWidget(
                  infoThemeColor: AppPallete.languageTileColour,
                  infoIcon: Image.asset(MediaRes.scoreboard),
                  infoTitle: 'Scores',
                  infoValue: user.point.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserInfoCardWidget(
                  infoThemeColor: AppPallete.physicsTileColour,
                  infoIcon: const Icon(
                    IconlyLight.user,
                    color: Color(0xFF56AEFF),
                    size: 24,
                  ),
                  infoTitle: 'followers',
                  infoValue: user.followers.length.toString(),
                ),
                UserInfoCardWidget(
                  infoThemeColor: AppPallete.chemistryTileColour,
                  infoIcon: const Icon(
                    IconlyLight.user,
                    size: 24,
                  ),
                  infoTitle: 'Following',
                  infoValue: user.following.length.toString(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
