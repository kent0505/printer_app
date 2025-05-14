import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/my_colors.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../core/widgets/main_button.dart';
import '../../home/screens/home_screen.dart';
import '../data/onboard_repository.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  static const routePath = '/OnboardScreen';

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int index = 0;
  final pageController = PageController();

  void onNext() async {
    if (index == 2) {
      await context.read<OnboardRepository>().removeOnboard();
      if (mounted) {
        context.go(HomeScreen.routePath);
      }
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        index++;
      });
    }
  }

  void onPageChanged(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MyColors>()!;

    return Scaffold(
      backgroundColor: colors.bgTwo,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                ImageWidget(Assets.onboard1),
                ImageWidget(Assets.onboard2),
                ImageWidget(Assets.onboard3),
              ],
            ),
          ),
          Container(
            height: 288,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.bgOne,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 4,
                      dotColor: colors.tertiaryOne,
                      activeDotColor: colors.accentPrimary,
                    ),
                    controller: pageController,
                    count: 3,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  index == 0
                      ? 'Fast Document Scanning and Printing'
                      : index == 1
                          ? 'Connect to Any Printer, Effortlessly'
                          : 'Fast Edit your PDF and Print',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 32,
                    fontFamily: AppFonts.inter700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  index == 0
                      ? 'Scan files to PDF, edit, and print with ease'
                      : index == 1
                          ? 'Connect to 8,000+ printers—any brand, no hassle'
                          : 'Quickly edit text, highlight, and organize your PDFs',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontFamily: AppFonts.inter400,
                  ),
                ),
                const Spacer(),
                MainButton(
                  title: 'Continue',
                  onPressed: onNext,
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
