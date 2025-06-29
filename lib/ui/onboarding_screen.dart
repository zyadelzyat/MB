import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home__Page/00_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI FIT MASTER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFB3A0FF),
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingModel {
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;
  final IconData? icon;
  final Color backgroundColor;

  const OnboardingModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
    this.icon,
    this.backgroundColor = const Color(0xFFB3A0FF),
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = [
    const OnboardingModel(
      title: "Welcome to",
      subtitle: "",
      image: "assets/onboarding1.jpg",
      buttonText: "",
      backgroundColor: Colors.transparent,
    ),
    const OnboardingModel(
      title: "Start Your Journey Towards A More Active Lifestyle",
      subtitle: "",
      image: "assets/onboarding2.jpg",
      buttonText: "Next",
      icon: Icons.fitness_center,
    ),
    const OnboardingModel(
      title: "Find Nutrition Tips That Fit Your Lifestyle",
      subtitle: "",
      image: "assets/onboarding3.jpg",
      buttonText: "Next",
      icon: Icons.apple,
    ),
    const OnboardingModel(
      title: "A Community For You, Challenge Yourself",
      subtitle: "",
      image: "assets/onboarding4.jpg",
      buttonText: "Get Started",
      icon: Icons.people,
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // ⏱️ التايمر لتحويل الصفحة الأولى تلقائيًا
    Future.delayed(const Duration(seconds: 5), () {
      if (_currentPage == 0 && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          return _buildOnboardingPage(index);
        },
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    final isLastPage = index == _pages.length - 1;
    final isFirstPage = index == 0;
    final model = _pages[index];

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              model.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          if (!isFirstPage && !isLastPage)
            Positioned(
              top: 40,
              right: 20,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: Row(
                  children: [
                    Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.yellow[300],
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.yellow[300],
                    ),
                  ],
                ),
              ),
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isFirstPage)
                  Column(
                    children: [
                      const Text(
                        "Welcome to",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/logo.png',
                        width: 180,
                      ),
                    ],
                  )
                else
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3A0FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (model.icon != null)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.yellow[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              model.icon,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          model.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _pages.length - 1,
                                (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: _currentPage - 1 == i
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                if (!isFirstPage)
                  Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (isLastPage) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        model.buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
