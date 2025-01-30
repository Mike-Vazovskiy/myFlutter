import 'package:flutter/material.dart';

// Нужно заменить на ваши собственные пути:
import '../screens/chat_list_screen.dart';        // или любой другой экран, куда вы хотите переходить
import '../widgets/custom_button.dart';
import '../widgets/fade_in_animation.dart';
import '../widgets/spacer.dart';
import '../constants/colors.dart';
import '../utils/helpers.dart';
import '../widgets/responsive_layout.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      body: Stack(
        children: [
          Center(
            child: ResponsiveLayout(
              mobileScreen: buildMobile(context),
              desktopScreen: buildDesktop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/onboarding_image.png'),
          Text(
            'Добро пожаловать в ChatGPT UI',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(16),
          Text(
            'Здесь может быть краткое описание возможностей приложения.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          addVerticalSpace(24),
          CustomButton(
            text: 'Начать',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatListScreen()),
              );
            },
            color: Colors.blue,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  Widget buildDesktop(BuildContext context) {
    // Аналогично для десктопа
    return buildMobile(context); // или свой layout
  }
}
