import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomBar extends StatefulWidget {
  final Function(int) onTabTapped;

  const BottomBar({Key? key, required this.onTabTapped}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTabTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xff363636),
      shape: const CircularNotchedRectangle(),
      notchMargin: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home button
            GestureDetector(
              onTap: () => _onItemTapped(0), // Index page
              child: Container(
                width: 70,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      "assets/index_icon.svg",
                      height: 20,
                      width: 20,
                      color: _currentIndex == 0 ? Colors.white : Colors.grey, // Highlight on selection
                    ),
                    const SizedBox(height: 8),
                    Text('Home',
                        style: TextStyle(
                          color: _currentIndex == 0 ? Colors.white : Colors.grey,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ),
            ),
            // Calendar button
            GestureDetector(
              onTap: () => _onItemTapped(1), // Calendar page
              child: Container(
                width: 70,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/calendar_icon.svg',
                      height: 20,
                      width: 20,
                      color: _currentIndex == 1 ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text('Calendar',
                        style: TextStyle(
                          color: _currentIndex == 1 ? Colors.white : Colors.grey,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 40), // Space for the floating button

            // Focus button
            GestureDetector(
              onTap: () => _onItemTapped(2), // Focus page
              child: Container(
                width: 70,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/clock.svg',
                      height: 20,
                      width: 20,
                      color: _currentIndex == 2 ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text('Focus',
                        style: TextStyle(
                          color: _currentIndex == 2 ? Colors.white : Colors.grey,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ),
            ),
            // Profile button
            GestureDetector(
              onTap: () => _onItemTapped(3), // Profile page
              child: Container(
                width: 70,
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/profile.svg',
                      height: 20,
                      width: 20,
                      color: _currentIndex == 3 ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text('Profile',
                        style: TextStyle(
                          color: _currentIndex == 3 ? Colors.white : Colors.grey,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
