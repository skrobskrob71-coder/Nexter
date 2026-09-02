import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('N', style: TextStyle(color: Colors.white, fontSize: 96, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('ناكستر Naxter', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            Text('النظام المحاسبي الذكي', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
