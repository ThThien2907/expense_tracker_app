import 'package:carousel_slider/carousel_slider.dart';
import 'package:expense_tracker_app/core/assets/app_images.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String subTitle;
  final String image;

  OnboardingData({
    required this.title,
    required this.subTitle,
    required this.image,
  });
}

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({super.key, required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  static List<OnboardingData> data(BuildContext context) => [
        OnboardingData(
          title: AppLocalizations.of(context)!.onboardingTitle1,
          subTitle: AppLocalizations.of(context)!.onboardingSubTitle1,
          image: AppImages.onboardingImage1,
        ),
        OnboardingData(
          title: AppLocalizations.of(context)!.onboardingTitle2,
          subTitle: AppLocalizations.of(context)!.onboardingSubTitle2,
          image: AppImages.onboardingImage2,
        ),
        OnboardingData(
          title: AppLocalizations.of(context)!.onboardingTitle3,
          subTitle: AppLocalizations.of(context)!.onboardingSubTitle3,
          image: AppImages.onboardingImage3,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3,
      itemBuilder: (context, index, pageIndex) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Image.asset(
                data(context)[index].image,
                width: 312,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    data(context)[index].title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: MediaQuery.of(context).size.width < 315 ? 26 : 32,
                      color: AppColors.dark50,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    data(context)[index].subTitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: AppColors.light20,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
          height: double.infinity,
          aspectRatio: 1,
          enableInfiniteScroll: true,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 400),
          onPageChanged: (index, reason) {
            onPageChanged(index);
          }),
    );
  }
}
