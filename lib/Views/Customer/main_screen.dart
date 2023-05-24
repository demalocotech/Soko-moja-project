import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/cart_screen.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/category_screen.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/home_screen.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/market_screen.dart';
import 'package:sokomoja_project/Views/Customer/nav_screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    MarketScreen(),
    CategoryScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        selectedItemColor: Color.fromARGB(255, 4, 54, 7),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/house-solid.svg',
              width: 25,
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/store-solid.svg',
              width: 25,
            ),
            label: 'MARKET',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/list-solid.svg',
              width: 25,
            ),
            label: 'CATEGORY',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/cart-shopping-solid.svg',
              width: 25,
            ),
            label: 'CART',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/user-solid.svg',
              width: 25,
            ),
            label: 'PROFILE',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
