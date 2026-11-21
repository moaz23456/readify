import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/features/authentication/auth_gate.dart';

import 'core/theme/app_theme.dart';

class Onbourding extends StatefulWidget {
  const Onbourding({super.key});

  @override
  State<Onbourding> createState() => _OnbourdingState();
}

class _OnbourdingState extends State<Onbourding> {
  PageController pageController = PageController();

  int currentindex = 0;

  List<Map<String, String>> onboardingData = [
    {
      "image": 'assets/images/firstonbourd.png',
      "title": "Readify",
      "description":
      "The reading of all good books is like conversation \n "
          "with the finest (people) of the past centuries."
    },
    {
      "image": 'assets/images/secondonbourd.png',
      "title": "Readify",
      "description": "Books are a uniquely portable magic"
    },
    {
      "image": 'assets/images/thirdonbourd.png',
      "title": "Readify",
      "description":
      "The more that you read, the more things you will know."
          "\n The more that you learn, the more places you’ll go."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            onboardingData[currentindex]['image']!,
            key: ValueKey(currentindex),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AuthGate();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        "Skip ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentindex = index;
                        });
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(height: 15),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  onboardingData[index]['title']!,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  onboardingData[index]['description']!,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontFamily: AppTheme.fontFamily,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) {
                      bool isSelected = currentindex == index;

                      return Container(
                        width: isSelected ? 20 : 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (currentindex < onboardingData.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear,
                          );
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AuthGate(),
                            ),
                          );
                        }
                      },
                      child: Text(
                        currentindex == onboardingData.length - 1
                            ? "Get started"
                            : "Next",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}