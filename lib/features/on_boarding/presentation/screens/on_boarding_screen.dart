import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/common/screens/loading_screen.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/themes/app_font.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:education_app/features/on_boarding/domain/entities/page_content.dart';
import 'package:education_app/features/on_boarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/features/on_boarding/presentation/widgets/on_boarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const String routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnboardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnboardingStatus && !state.isFirstTimer) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is UserCached) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          builder: (context, state) {
            if (state is CheckingIfUserIsFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingScreen();
            }

            return Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnBoardingContent(pageContent: PageContent.first()),
                    OnBoardingContent(pageContent: PageContent.second()),
                    OnBoardingContent(pageContent: PageContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, .04),
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      dotColor: Colors.white,
                      spacing: 40,
                      activeDotColor: AppPallete.primaryColour,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: context.widht * .30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 17,
                      ),
                      backgroundColor: AppPallete.primaryColour,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // cache user
                      context.read<OnboardingCubit>().cacheFirstTimer();
                      // push them to the appropriate screen
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontFamily: AppFont.aeonik,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
