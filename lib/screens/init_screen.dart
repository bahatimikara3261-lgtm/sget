import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

class InitScreen extends StatefulWidget {
  static String routeName = "/";

  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  // Couleurs du logo Jiwekee Akiba
  static const Color logoGreen = Color.fromRGBO(146, 239, 158, 1);
  static const Color logoBlue = Color.fromRGBO(57, 188, 245, 1);
  static const Color logoDarkBlue = Color.fromRGBO(34, 70, 109, 1);
  static const Color backgroundColor = Color.fromRGBO(211, 232, 236, 1);

  void _updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const FavoriteScreen(),
    const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "Chat",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Fonctionnalité à venir",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background Jiwekee Akiba
      body: _pages[currentSelectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: logoDarkBlue.withOpacity(0.1), // Ombre bleu foncé
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          onTap: _updateCurrentIndex,
          currentIndex: currentSelectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          selectedItemColor: logoDarkBlue, // Bleu foncé Jiwekee Akiba
          unselectedItemColor: Colors.grey[600], // Gris pour inactif
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                colorFilter: ColorFilter.mode(
                  Colors.grey[600]!, // Gris pour inactif
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/Shop Icon.svg",
                colorFilter: const ColorFilter.mode(
                  logoDarkBlue, // Bleu foncé Jiwekee Akiba
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                colorFilter: ColorFilter.mode(
                  Colors.grey[600]!, // Gris pour inactif
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/Heart Icon.svg",
                colorFilter: const ColorFilter.mode(
                  logoDarkBlue, // Bleu foncé Jiwekee Akiba
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              label: "Favoris",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/Chat bubble Icon.svg",
                colorFilter: ColorFilter.mode(
                  Colors.grey[600]!, // Gris pour inactif
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/Chat bubble Icon.svg",
                colorFilter: const ColorFilter.mode(
                  logoDarkBlue, // Bleu foncé Jiwekee Akiba
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                colorFilter: ColorFilter.mode(
                  Colors.grey[600]!, // Gris pour inactif
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                colorFilter: const ColorFilter.mode(
                  logoDarkBlue, // Bleu foncé Jiwekee Akiba
                  BlendMode.srcIn,
                ),
                height: 24,
              ),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}