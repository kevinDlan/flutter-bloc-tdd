import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilHeaderWidget extends StatelessWidget {
  const ProfilHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, provider, __) {
        final user = provider.user;
        final image = user?.profilPic == null || user!.profilPic!.isEmpty
            ? null
            : user.profilPic;
        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: image != null
                  ? NetworkImage(image)
                  : const AssetImage(MediaRes.user) as ImageProvider,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user?.fullName ?? 'No User',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 26),
            ),
            if (user?.bio != null && user!.bio!.isNotEmpty) ...[
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.widht * .15),
                child: Text(
                  user.bio ?? 'No bio',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppPallete.neutralTextColour,
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }
}
