import 'package:flutter/material.dart';

import 'components/discount_banner.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor, // Background Jiwekee Akiba
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              DiscountBanner(),
              SpecialOffers(),
            ],
          ),
        ),
      ),
    );
  }
}