import 'package:flutter/material.dart';
import '../main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController(text: 'admin');
  final password = TextEditingController();
  String role = 'مدير';

  void login() {
    if (username.text.trim().isEmpty) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => MainScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Text('N', style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
                      const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 22),
                      TextField(controller: username, decoration: const InputDecoration(labelText: 'اسم المستخدم', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 14),
                      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(value: role, decoration: const InputDecoration(labelText: 'الصلاحية', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'مدير', child: Text('مدير')), DropdownMenuItem(value: 'محاسب', child: Text('محاسب')), DropdownMenuItem(value: 'كاشير', child: Text('كاشير'))], onChanged: (value) => setState(() => role = value ?? 'مدير')),
                      const SizedBox(height: 20),
                      SizedBox(width: double.infinity, height: 50, child: FilledButton(onPressed: login, child: const Text('تسجيل الدخول'))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
