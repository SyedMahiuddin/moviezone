import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moviezone/Views/home_screen.dart';
import 'package:moviezone/Views/map_page.dart';
import 'package:moviezone/Views/profile_page.dart';
import 'package:moviezone/Views/saved_movies.dart';

import '../Helpers/color_helper.dart';


class OpalBottomNavBar extends StatefulWidget {
  @override
  _OpalBottomNavBarState createState() => _OpalBottomNavBarState();
}

class _OpalBottomNavBarState extends State<OpalBottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  final List<Widget> _screens = [
    HomePage(),
    SavedMoviesPage(),
    MapScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryTheme,
      body:
       _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: ColorHelper.primaryTheme,
          selectedItemColor: ColorHelper.secondryTheme,
          unselectedItemColor: ColorHelper.primaryText.withOpacity(0.7),
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24.w),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 24.w),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined, size: 24.w),
              label: 'NearBy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 24.w),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
          selectedFontSize: 12.sp,
          unselectedFontSize: 10.sp,
          iconSize: 28.w,
        ),
      ),
    );
  }
}
