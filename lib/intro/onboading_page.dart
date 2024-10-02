import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../start_screen/start_screen_page.dart';
import '../widgets/appbar_widget.dart';
import 'onboading_viewmodel.dart';
import '../widgets/button_widget.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final introViewModel = Provider.of<IntroViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWidget(
        title: '',
        leftWidget: TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StartScreenPage(),
              ),
            );
            print("on press");
          },
          child: const Text(
            'SKIP',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Jost',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center( // Wrap the PageView in Center to center it vertically and horizontally
              child: Container(
                color: Colors.transparent,
                height: 480,
                constraints: BoxConstraints(maxWidth: 350), // Optional: Set max width for better layout
                child: PageView.builder(
                  controller: introViewModel.pageController,
                  onPageChanged: introViewModel.onPageChanged,
                  itemCount: introViewModel.pages.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            introViewModel.pages[index]['image'] ?? '',
                            width: 300,
                            height: 300,
                            placeholderBuilder: (BuildContext context) => Container(
                              width: 300,
                              height: 300,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SmoothPageIndicator(
                            controller: introViewModel.pageController,
                            count: introViewModel.pages.length,
                            effect: const SlideEffect(
                              dotHeight: 4,
                              dotWidth: 40,
                              activeDotColor: Colors.blue,
                              dotColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            introViewModel.pages[index]['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Jost',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          Text(
                            introViewModel.pages[index]['text'] ?? 'No description available',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Jost',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: introViewModel.previousPage,
                  child: const Text(
                    'BACK',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Jost',
                    ),
                  ),
                ),
                CustomButton(
                  text: 'NEXT',
                  onPressed: introViewModel.nextPage,
                  buttonColor: const Color(0xff8875FF),
                  borderRadius: 5,
                  buttonWidth: 80,
                  buttonHeight: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
