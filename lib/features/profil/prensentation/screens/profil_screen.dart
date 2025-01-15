import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/features/profil/prensentation/widgets/profil_app_bar_widget.dart';
import 'package:education_app/features/profil/prensentation/widgets/profil_body_widget.dart';
import 'package:education_app/features/profil/prensentation/widgets/profil_header_widget.dart';
import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const ProfilAppBarWidget(),
      body: GradientBackground(
        image: MediaRes.profileGradientBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: const [
            ProfilHeaderWidget(),
            ProfilBodyWidget(),
          ],
        ),
      ),
    );
  }
}
