import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'core/database/database_helper.dart';
import 'core/services/pdf_service.dart';

const Color navy = Color(0xFF0D47A1);
const Color pageBg = Color(0xFFF5F7FB);
final NumberFormat money = NumberFormat('#,##0.00', 'en');

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
        scaffoldBackgroundColor: pageBg,
        colorScheme: ColorScheme.fromSeed(seedColor: navy),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), filled: true, fillColor: Colors.white),
      ),
      home: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override State<SplashPage> createState() => _SplashPageState();
}
class _SplashPageState extends State<SplashPage> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 2), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())); }); }
  @override Widget build(BuildContext context) => const Scaffold(backgroundColor: navy, body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [CircleAvatar(radius: 48, backgroundColor: Colors.white, child: Text('N', style: TextStyle(color: navy, fontSize: 58, fontWeight: FontWeight.bold))), SizedBox(height: 16), Text('ناكستر Naxter', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), Text('إدارة أعمالك بثقة', style: TextStyle(color: Colors.white70))])));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final user = TextEditingController(text: 'admin');
  final pass = TextEditingController(text: '1234');
  @override void dispose() { user.dispose(); pass.dispose(); super.dispose(); }
  void login() {
    if (user.text.trim().isEmpty || pass.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل بيانات الدخول')));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell()));
  }
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(children: [const CircleAvatar(radius: 38, backgroundColor: navy, child: Text('N', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold))), const SizedBox(height: 16), const Text('مرحباً بك في ناكستر', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 24), TextField(controller: user, decoration: const InputDecoration(labelText: 'اسم المستخدم', prefixIcon: Icon(Icons.person))), const SizedBox(height: 14), TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock))), const SizedBox(height: 22), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: login, icon: const Icon(Icons.login), label: const Padding(padding: EdgeInsets.all(12), child: Text('تسجيل الدخول'))))]))))));
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}
class _HomeShellState extends State<HomeShell> {
  int tab = 0;
  final titles = const ['لوحة التحكم', 'الفواتير', 'العملاء', 'المنتجات', 'التقارير'];
  void refresh() => setState(() {});
  @override Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardPage(key: ValueKey(tab)),
      InvoicesPage(onChanged: refresh),
      CustomersPage(onChanged: refresh),
      ProductsPage(onChanged: refresh),
      const ReportsPage(),
    ];
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(title: Text(titles[tab]), backgroundColor: Colors.white, actions: [IconButton(onPressed: refresh, icon: const Icon(Icons.refresh)), IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())), icon: const Icon(Icons.settings))]),
      drawer: AppDrawer(onSelected: (value) { Navigator.pop(context); if (value == 5) { Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())); } else { setState(() => tab = value); } }),
      body: pages[tab],
      bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (value) => setState(() => tab = value), destinations: const [NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'الرئيسية'), NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'الفواتير'), NavigationDestination(icon: Icon(Icons.people_outline), label: 'العملاء'), NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'المنتجات'), NavigationDestination(icon: Icon(Icons.analytics_outlined), label: 'التقارير')]),
    ));
  }
}

class AppDrawer extends StatelessWidget {
  final ValueChanged<int> onSelected;
  const AppDrawer({required this.onSelected, super.key});
  @override Widget build(BuildContext context) => Drawer(child: ListView(padding: EdgeInsets.zero, children: [const UserAccountsDrawerHeader(decoration: BoxDecoration(color: navy), accountName: Text('ناكستر Naxter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), accountEmail: Text('نظام محاسبي متكامل'), currentAccountPicture: CircleAvatar(backgroundColor: Colors.white, child: Text('N', style: TextStyle(color: navy, fontSize: 30, fontWeight: FontWeight.bold)))), _item(Icons.dashboard, 'لوحة التحكم', 0), _item(Icons.receipt_long, 'الفواتير', 1), _item(Icons.people, 'العملاء', 2), _item(Icons.inventory_2, 'المنتجات والمخزون', 3), _item(Icons.analytics, 'التقارير', 4), const Divider(), _item(Icons.settings, 'الإعدادات', 5)]));
  Widget _item(IconData icon, String text, int value) => ListTile(leading: Icon(icon, color: navy), title: Text(text), onTap: () => onSelected(value));
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override Widget build(BuildContext context) => FutureBuilder<Map<String, num>>(future: DatabaseHelper.instance.summary(), builder: (context, summary) {
    return FutureBuilder<List<double>>(future: DatabaseHelper.instance.monthlySales(), builder: (context, chart) {
      final data = summary.data ?? <String, num>{};
      final values = chart.data ?? List<double>.filled(6, 0);
      return ListView(padding: const EdgeInsets.all(16), children: [const Text('نظرة عامة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), Text(DateFormat('EEEE، d MMMM y', 'ar').format(DateTime.now()), style: const TextStyle(color: Colors.black54)), const SizedBox(height: 18), Wrap(spacing: 10, runSpacing: 10, children: [_metric('إجمالي المبيعات', data['sales'] ?? 0, Icons.trending_up, Colors.green), _metric('صافي الربح', data['profit'] ?? 0, Icons.account_balance_wallet, navy), _metric('عدد العملاء', data['customers'] ?? 0, Icons.people, Colors.orange), _metric('عدد المنتجات', data['products'] ?? 0, Icons.inventory_2, Colors.purple)]), const SizedBox(height: 18), Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('المبيعات خلال آخر 6 أشهر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 16), SizedBox(height: 230, child: LineChart(LineChartData(minY: 0, gridData: const FlGridData(show: true), titlesData: const FlTitlesData(rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))), lineBarsData: [LineChartBarData(spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])], isCurved: true, barWidth: 4, color: navy)])))])))];
    });
  });
}
Widget _metric(String title, num value, IconData icon, Color color) => SizedBox(width: 178, child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [CircleAvatar(backgroundColor: color.withOpacity(.12), child: Icon(icon, color: color)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12)), Text(money.format(value), style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: color))]))])));

class InvoicesPage extends StatefulWidget { final VoidCallback onChanged; const InvoicesPage({required this.onChanged, super.key}); @override State<InvoicesPage> createState() => _InvoicesPageState(); }
class _InvoicesPageState extends State<InvoicesPage> {
  List<Map<String, dynamic>> rows = [];
  @override void initState() { super.initState(); load(); }
  Future<void> load() async { rows = await DatabaseHelper.instance.all('invoices'); if (mounted) setState(() {}); }
  Future<void> create() async { final ok = await Navigator.push(context, MaterialPageRoute(builder: (_) => const NewInvoicePage())); if (ok == true) { await load(); widget.onChanged(); } }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('سجل الفواتير', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), FilledButton.icon(onPressed: create, icon: const Icon(Icons.add), label: const Text('فاتورة جديدة'))]), const SizedBox(height: 14), if (rows.isEmpty) const EmptyState(icon: Icons.receipt_long, text: 'لا توجد فواتير بعد') else ...rows.map((row) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.receipt)), title: Text('فاتورة ${row['number']}'), subtitle: Text('${row['customer_name']} • ${row['created_at'].toString().substring(0, 10)}'), trailing: Text('${money.format(row['total'])} ر.س', style: const TextStyle(fontWeight: FontWeight.bold, color: navy)), onTap: () => PdfService.printInvoice(number: row['number'].toString(), customer: row['customer_name'].toString(), subtotal: row['subtotal'] as num, tax: row['tax'] as num, total: row['total'] as num))))]);
}

class CustomersPage extends StatefulWidget { final VoidCallback onChanged; const CustomersPage({required this.onChanged, super.key}); @override State<CustomersPage> createState() => _CustomersPageState(); }
class _CustomersPageState extends State<CustomersPage> {
  List<Map<String, dynamic>> rows = [];
  @override void initState() { super.initState(); load(); }
  Future<void> load() async { rows = await DatabaseHelper.instance.all('customers'); if (mounted) setState(() {}); }
  Future<void> add() async { if (await showDialog<bool>(context: context, builder: (_) => const CustomerDialog()) == true) { await load(); widget.onChanged(); } }
  Future<void> remove(int id) async { await DatabaseHelper.instance.delete('customers', id); await load(); widget.onChanged(); }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('العملاء', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), FilledButton.icon(onPressed: add, icon: const Icon(Icons.person_add), label: const Text('إضافة عميل'))]), const SizedBox(height: 14), if (rows.isEmpty) const EmptyState(icon: Icons.people_outline, text: 'أضف أول عميل') else ...rows.map((row) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.person)), title: Text(row['name'].toString()), subtitle: Text(row['phone'].toString().isEmpty ? 'لا يوجد رقم جوال' : row['phone'].toString()), trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => remove(row['id'] as int)))))]);
}

class ProductsPage extends StatefulWidget { final VoidCallback onChanged; const ProductsPage({required this.onChanged, super.key}); @override State<ProductsPage> createState() => _ProductsPageState(); }
class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> rows = [];
  @override void initState() { super.initState(); load(); }
  Future<void> load() async { rows = await DatabaseHelper.instance.all('products'); if (mounted) setState(() {}); }
  Future<void> add() async { if (await showDialog<bool>(context: context, builder: (_) => const ProductDialog()) == true) { await load(); widget.onChanged(); } }
  Future<void> remove(int id) async { await DatabaseHelper.instance.delete('products', id); await load(); widget.onChanged(); }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('المنتجات والمخزون', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), FilledButton.icon(onPressed: add, icon: const Icon(Icons.add_box), label: const Text('إضافة صنف'))]), const SizedBox(height: 14), if (rows.isEmpty) const EmptyState(icon: Icons.inventory_2_outlined, text: 'أضف أول صنف') else ...rows.map((row) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.inventory_2)), title: Text(row['name'].toString()), subtitle: Text('الكمية: ${row['quantity']} • البيع: ${money.format(row['sale_price'])} ر.س'), trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => remove(row['id'] as int)))))]);
}

class CustomerDialog extends StatefulWidget { const CustomerDialog({super.key}); @override State<CustomerDialog> createState() => _CustomerDialogState(); }
class _CustomerDialogState extends State<CustomerDialog> {
  final name = TextEditingController(); final phone = TextEditingController();
  @override void dispose() { name.dispose(); phone.dispose(); super.dispose(); }
  Future<void> save() async { if (name.text.trim().isEmpty) return; await DatabaseHelper.instance.insert('customers', {'name': name.text.trim(), 'phone': phone.text.trim(), 'address': '', 'balance': 0, 'created_at': DateTime.now().toIso8601String()}); if (mounted) Navigator.pop(context, true); }
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('إضافة عميل'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم العميل')), const SizedBox(height: 12), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الجوال'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), FilledButton(onPressed: save, child: const Text('حفظ'))]);
}

class ProductDialog extends StatefulWidget { const ProductDialog({super.key}); @override State<ProductDialog> createState() => _ProductDialogState(); }
class _ProductDialogState extends State<ProductDialog> {
  final name = TextEditingController(); final barcode = TextEditingController(); final qty = TextEditingController(text: '0'); final purchase = TextEditingController(text: '0'); final sale = TextEditingController(text: '0');
  @override void dispose() { for (final controller in [name, barcode, qty, purchase, sale]) { controller.dispose(); } super.dispose(); }
  Future<void> save() async { if (name.text.trim().isEmpty) return; await DatabaseHelper.instance.insert('products', {'name': name.text.trim(), 'barcode': barcode.text.trim(), 'quantity': double.tryParse(qty.text) ?? 0, 'purchase_price': double.tryParse(purchase.text) ?? 0, 'sale_price': double.tryParse(sale.text) ?? 0, 'created_at': DateTime.now().toIso8601String()}); if (mounted) Navigator.pop(context, true); }
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('إضافة صنف'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم الصنف')), const SizedBox(height: 10), TextField(controller: barcode, decoration: const InputDecoration(labelText: 'الباركود')), const SizedBox(height: 10), TextField(controller: qty, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'الكمية')), const SizedBox(height: 10), TextField(controller: purchase, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعر الشراء')), const SizedBox(height: 10), TextField(controller: sale, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'سعر البيع'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')), FilledButton(onPressed: save, child: const Text('حفظ'))]);
}

class NewInvoicePage extends StatefulWidget { const NewInvoicePage({super.key}); @override State<NewInvoicePage> createState() => _NewInvoicePageState(); }
class _NewInvoicePageState extends State<NewInvoicePage> {
  final amount = TextEditingController(); List<Map<String, dynamic>> customers = []; int? customerId; String customerName = 'نقدي';
  @override void initState() { super.initState(); load(); }
  @override void dispose() { amount.dispose(); super.dispose(); }
  Future<void> load() async { customers = await DatabaseHelper.instance.all('customers'); if (mounted) setState(() {}); }
  Future<void> save({required bool print}) async { final subtotal = double.tryParse(amount.text.replaceAll(',', '')) ?? 0; if (subtotal <= 0) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أدخل مبلغاً صحيحاً'))); return; } final tax = subtotal * .15; final total = subtotal + tax; final number = 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'; final invoiceId = await DatabaseHelper.instance.insert('invoices', {'number': number, 'customer_id': customerId, 'customer_name': customerName, 'subtotal': subtotal, 'tax': tax, 'total': total, 'created_at': DateTime.now().toIso8601String()}); await DatabaseHelper.instance.insert('invoice_items', {'invoice_id': invoiceId, 'product_id': null, 'product_name': 'فاتورة مباشرة', 'quantity': 1, 'price': subtotal, 'total': subtotal}); if (print) await PdfService.printInvoice(number: number, customer: customerName, subtotal: subtotal, tax: tax, total: total); if (mounted) Navigator.pop(context, true); }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('فاتورة جديدة')), body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [DropdownButtonFormField<int?>(value: customerId, decoration: const InputDecoration(labelText: 'العميل'), items: [const DropdownMenuItem<int?>(value: null, child: Text('نقدي')), ...customers.map((row) => DropdownMenuItem<int?>(value: row['id'] as int, child: Text(row['name'].toString())))], onChanged: (value) { setState(() { customerId = value; customerName = value == null ? 'نقدي' : customers.firstWhere((row) => row['id'] == value)['name'].toString(); }); }), const SizedBox(height: 16), TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'المبلغ قبل الضريبة', prefixText: 'ر.س ')), const SizedBox(height: 16), ValueListenableBuilder<TextEditingValue>(valueListenable: amount, builder: (context, value, child) { final subtotal = double.tryParse(value.text) ?? 0; return Column(children: [_line('قبل الضريبة', subtotal), _line('الضريبة 15%', subtotal * .15), _line('الإجمالي', subtotal * 1.15, bold: true)]); })]))), const SizedBox(height: 16), Row(children: [Expanded(child: OutlinedButton(onPressed: () => save(print: false), child: const Text('حفظ'))), const SizedBox(width: 10), Expanded(child: FilledButton.icon(onPressed: () => save(print: true), icon: const Icon(Icons.print), label: const Text('حفظ وطباعة')))])]));
  Widget _line(String label, double value, {bool bold = false}) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)), Text('${money.format(value)} ر.س', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: bold ? navy : null))]));
}

class ReportsPage extends StatelessWidget { const ReportsPage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(16), children: [const Text('التقارير', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 14), _report(context, 'تقرير المبيعات', Icons.receipt_long), _report(context, 'تقرير الأرباح والخسائر', Icons.account_balance), _report(context, 'كشف حساب العملاء', Icons.people)]); Widget _report(BuildContext context, String title, IconData icon) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: navy.withOpacity(.1), child: Icon(icon, color: navy)), title: Text(title), trailing: const Icon(Icons.chevron_left), onTap: () async { final data = await DatabaseHelper.instance.summary(); if (!context.mounted) return; showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: Text('إجمالي المبيعات: ${money.format(data['sales'] ?? 0)} ر.س\nصافي الربح: ${money.format(data['profit'] ?? 0)} ر.س\nعدد العملاء: ${data['customers'] ?? 0}'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق'))])); })); }

class SettingsPage extends StatelessWidget { const SettingsPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الإعدادات')), body: ListView(padding: const EdgeInsets.all(12), children: [Card(child: ListTile(leading: const Icon(Icons.business, color: navy), title: const Text('بيانات الشركة'), subtitle: const Text('ناكستر للمحاسبة'))), Card(child: ListTile(leading: const Icon(Icons.print, color: navy), title: const Text('اختبار طباعة فاتورة'), onTap: () => PdfService.printInvoice(number: 'TEST-001', customer: 'عميل تجريبي', subtotal: 100, tax: 15, total: 115))), const Card(child: ListTile(leading: Icon(Icons.backup, color: navy), title: Text('النسخ الاحتياطي'), subtitle: Text('قاعدة البيانات محفوظة محلياً'))), const Card(child: ListTile(leading: Icon(Icons.info, color: navy), title: Text('حول التطبيق'), subtitle: Text('ناكستر Naxter - الإصدار 1.0.0')))])); }

class EmptyState extends StatelessWidget { final IconData icon; final String text; const EmptyState({required this.icon, required this.text, super.key}); @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(34), child: Column(children: [Icon(icon, size: 54, color: Colors.grey), const SizedBox(height: 12), Text(text, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center)]))); }
