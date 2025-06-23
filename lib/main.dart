import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Login___Signup/01_signin_screen.dart';
import 'package:untitled/Store/Store.dart';
import 'theme.dart';
import 'theme_provider.dart';
import 'Set Up/06 WeightSelectionScreen.dart';
import 'Set Up/03 GenderSelectionScreen.dart';
import 'Home__Page/00_home_page.dart';
import 'package:untitled/rating/AddRatingPage.dart';
import 'ui/onboarding_screen.dart';
import 'Admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Firebase App Check
  await FirebaseAppCheck.instance.activate(
    // For Android, use debug provider during development
    androidProvider: AndroidProvider.debug,
    // For production, use: AndroidProvider.playIntegrity

    // For iOS (if you plan to support it)
    appleProvider: AppleProvider.debug,
    // For production iOS, use: AppleProvider.deviceCheck or AppleProvider.appAttest

    // For web (if you plan to support it)
    webProvider: ReCaptchaV3Provider('your-recaptcha-site-key'),
  );

  final prefs = await SharedPreferences.getInstance();
  bool firstLaunch = prefs.getBool('firstLaunch') ?? true;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: GenderSelectionApp(firstLaunch: firstLaunch),
    ),
  );
}

class GenderSelectionApp extends StatefulWidget {
  final bool firstLaunch;
  const GenderSelectionApp({super.key, required this.firstLaunch});

  @override
  _GenderSelectionAppState createState() => _GenderSelectionAppState();
}

class _GenderSelectionAppState extends State<GenderSelectionApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      // home: const OnboardingScreen(),
      // home: const SupplementsStorePage(),
      // home: OnboardingScreen(),
      // home: const WeightSelectionScreen(),
      // home: const GenderSelectionScreen(),
      // home: const SupplementsStorePage(),
      // home : AdminDashboard(),
      // home : const HomePage(),
      // home : const AddRatingPage(),
      home: widget.firstLaunch ? const OnboardingScreen() : _getInitialScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _getInitialScreen() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          // User is signed in, navigate to appropriate screen
          return const HomePage(); // or your appropriate authenticated screen
        } else {
          // User is not signed in
          return const SignInScreen();
        }
      },
    );
  }
}
