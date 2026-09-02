import 'package:flutter/material.dart';
import 'home/dashboard_screen.dart';
import 'invoices/invoices_screen.dart';
import 'customers/customers_screen.dart';
import 'products_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final String role;
  const MainScreen({super.key, this.role = 'مدير'});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selected = 0;
  final titles = const ['لوحة التحكم', 'الفواتير', 'العملاء', 'المنتجات', 'التقارير'];

  @override
  Widget build(BuildContext context) {
    final pages = const [DashboardScreen(), InvoicesScreen(), CustomersScreen(), ProductsScreen(), ReportsScreen()];
    return Scaffold(
      appBar: AppBar(title: Text(titles[selected])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(decoration: BoxDecoration(color: Color(0xFF0D47A1)), child: Center(child: Text('ناكستر Naxter', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)))),
            for (var i = 0; i < titles.length; i++) ListTile(leading: Icon([Icons.dashboard, Icons.receipt_long, Icons.people, Icons.inventory_2, Icons.bar_chart][i]), title: Text(titles[i]), selected: selected == i, onTap: () { setState(() => selected = i); Navigator.pop(context); }),
            const Divider(),
            ListTile(leading: const Icon(Icons.settings), title: const Text('الإعدادات'), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); }),
          ],
        ),
      ),
      body: Directionality(textDirection: TextDirection.rtl, child: pages[selected]),
      bottomNavigationBar: BottomNavigationBar(currentIndex: selected, type: BottomNavigationBarType.fixed, onTap: (value) => setState(() => selected = value), items: const [BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'), BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الفواتير'), BottomNavigationBarItem(icon: Icon(Icons.people), label: 'العملاء'), BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'المنتجات'), BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'التقارير')]),
    );
  }
}
