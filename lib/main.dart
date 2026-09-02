import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'core/database/database_helper.dart';
import 'core/services/pdf_service.dart';

void main() => runApp(const NaxterApp());

class NaxterApp extends StatelessWidget {
  const NaxterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ناكستر Naxter',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const Directionality(textDirection: TextDirection.rtl, child: SplashPage()),
    );
  }
}

class SplashPage extends StatefulWidget { const SplashPage({super.key}); @override State<SplashPage> createState() => _SplashPageState(); }
class _SplashPageState extends State<SplashPage> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 3), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())); }); }
  @override Widget build(BuildContext context) => const Scaffold(backgroundColor: Color(0xFF0D47A1), body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('N', style: TextStyle(fontSize: 96, color: Colors.white, fontWeight: FontWeight.bold)), Text('ناكستر Naxter', style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold))]));
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 18),
              const TextField(decoration: InputDecoration(labelText: 'اسم المستخدم', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder())),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())), child: const Text('تسجيل الدخول'))),
            ]),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState() => _HomePageState(); }
class _HomePageState extends State<HomePage> {
  int index = 0;
  final titles = const ['لوحة التحكم', 'الفواتير', 'العملاء', 'المنتجات', 'التقارير'];
  @override
  Widget build(BuildContext context) {
    const pages = [DashboardPage(), InvoicesPage(), CustomersPage(), ProductsPage(), ReportsPage()];
    return Scaffold(
      appBar: AppBar(title: Text(titles[index])),
      drawer: Drawer(child: ListView(children: [
        const DrawerHeader(decoration: BoxDecoration(color: Color(0xFF0D47A1)), child: Center(child: Text('ناكستر Naxter', style: TextStyle(color: Colors.white, fontSize: 24)))),
        ListTile(leading: const Icon(Icons.settings), title: const Text('الإعدادات'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
      ])),
      body: Directionality(textDirection: TextDirection.rtl, child: pages[index]),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'), NavigationDestination(icon: Icon(Icons.receipt), label: 'الفواتير'), NavigationDestination(icon: Icon(Icons.people), label: 'العملاء'), NavigationDestination(icon: Icon(Icons.inventory), label: 'المنتجات'), NavigationDestination(icon: Icon(Icons.bar_chart), label: 'التقارير'),
      ]),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => FutureBuilder<List<double>>(future: DatabaseHelper.instance.monthlySales(), builder: (context, snapshot) {
    final values = snapshot.data ?? List<double>.filled(6, 0);
    return ListView(padding: const EdgeInsets.all(16), children: [
      const Text('ملخص الحسابات', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1))),
      const SizedBox(height: 16),
      Wrap(spacing: 8, runSpacing: 8, children: const [StatCard('المبيعات', Icons.trending_up), StatCard('المشتريات', Icons.shopping_cart), StatCard('العملاء', Icons.people), StatCard('صافي الربح', Icons.account_balance_wallet)]),
      const SizedBox(height: 20),
      Card(child: Padding(padding: const EdgeInsets.all(12), child: SizedBox(height: 220, child: LineChart(LineChartData(gridData: const FlGridData(show: true), titlesData: const FlTitlesData(rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))), lineBarsData: [LineChartBarData(isCurved: true, color: const Color(0xFF0D47A1), spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])])])))),
      const Text('مبيعات آخر 6 شهور', textAlign: TextAlign.center),
    ]);
  });
}
class StatCard extends StatelessWidget { final String title; final IconData icon; const StatCard(this.title, this.icon, {super.key}); @override Widget build(BuildContext context) => SizedBox(width: 165, child: Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFF0D47A1)), Text(title), const Text('0.00 ر.س', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))])))); }

class InvoicesPage extends StatelessWidget { const InvoicesPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [Align(alignment: Alignment.centerLeft, child: FilledButton.icon(onPressed: () => showDialog(context: context, builder: (_) => const InvoiceDialog()), icon: const Icon(Icons.add), label: const Text('فاتورة جديدة'))), const SizedBox(height: 12), const Card(child: ListTile(title: Text('لا توجد فواتير بعد'), subtitle: Text('أضف أول فاتورة من الزر أعلاه')))]); }
class InvoiceDialog extends StatelessWidget { const InvoiceDialog({super.key}); @override Widget build(BuildContext context) => AlertDialog(title: const Text('فاتورة جديدة'), content: const TextField(decoration: InputDecoration(labelText: 'المبلغ قبل الضريبة')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('حفظ'))]); }
class CustomersPage extends StatelessWidget { const CustomersPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.person_add), label: const Text('إضافة عميل')), const SizedBox(height: 12), const Card(child: ListTile(title: Text('العملاء'), subtitle: Text('لا توجد بيانات بعد')))]); }
class ProductsPage extends StatelessWidget { const ProductsPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add_box), label: const Text('إضافة صنف')), const SizedBox(height: 12), const Card(child: ListTile(title: Text('المنتجات والمخزون'), subtitle: Text('لا توجد أصناف بعد')))]); }
class ReportsPage extends StatelessWidget { const ReportsPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [for (final title in ['تقرير المبيعات', 'تقرير الأرباح والخسائر', 'كشف حساب عميل']) Card(child: ListTile(leading: const Icon(Icons.assessment), title: Text(title)))]); }
class SettingsPage extends StatelessWidget { const SettingsPage({super.key}); @override Widget build(BuildContext context) => ListView(children: [const ListTile(leading: Icon(Icons.business), title: Text('بيانات الشركة')), ListTile(leading: const Icon(Icons.print), title: const Text('طباعة فاتورة تجريبية'), onTap: () => PdfService.printInvoice(number: 'TEST-001', customer: 'عميل', subtotal: 100, tax: 15, total: 115)), const ListTile(leading: Icon(Icons.backup), title: Text('النسخ الاحتياطي')), const ListTile(leading: Icon(Icons.info), title: Text('حول التطبيق'))]); }
