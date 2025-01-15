import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/themes/app_font.dart';
import 'package:education_app/features/on_boarding/domain/entities/page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    required this.pageContent,
    super.key,
  });
  final PageContent pageContent;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * .4,
        ),
        SizedBox(
          height: context.height * .03,
        ),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              Text(
                pageContent.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFont.aeonik,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: context.height * .02,
              ),
              Text(
                pageContent.description,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontFamily: AppFont.poppins, fontSize: 14),
              ),
              SizedBox(
                height: context.height * .05,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
