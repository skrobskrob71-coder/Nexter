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
      theme: ThemeData(useMaterial3: true, fontFamily: 'Cairo', colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1))),
      home: const Directionality(textDirection: TextDirection.rtl, child: SplashPage()),
    );
  }
}

class SplashPage extends StatefulWidget { const SplashPage({super.key}); @override State<SplashPage> createState()=>_SplashPageState(); }
class _SplashPageState extends State<SplashPage> {
  @override void initState(){super.initState();Future.delayed(const Duration(seconds:3),(){if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const LoginPage()));});}
  @override Widget build(BuildContext context){return const Scaffold(backgroundColor:Color(0xFF0D47A1),body:Center(child:Text('ناكستر Naxter',style:TextStyle(color:Colors.white,fontSize:32,fontWeight:FontWeight.bold))));}
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('تسجيل الدخول'),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: 'اسم المستخدم')),
              const SizedBox(height: 12),
              const TextField(obscureText: true, decoration: InputDecoration(labelText: 'كلمة المرور')),
              const SizedBox(height: 16),
              FilledButton(onPressed: () { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())); }, child: const Text('دخول')),
            ]),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage>{int index=0;final names=const['الرئيسية','الفواتير','العملاء','المنتجات','التقارير'];@override Widget build(BuildContext context){const pages=[DashboardPage(),InvoicesPage(),CustomersPage(),ProductsPage(),ReportsPage()];return Scaffold(appBar:AppBar(title:Text(names[index])),drawer:Drawer(child:ListView(children:[const DrawerHeader(decoration:BoxDecoration(color:Color(0xFF0D47A1)),child:Center(child:Text('ناكستر Naxter',style:TextStyle(color:Colors.white,fontSize:24)))),ListTile(title:const Text('الإعدادات'),leading:const Icon(Icons.settings),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const SettingsPage())))])),body:pages[index],bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(v)=>setState(()=>index=v),destinations:const[NavigationDestination(icon:Icon(Icons.dashboard),label:'الرئيسية'),NavigationDestination(icon:Icon(Icons.receipt),label:'الفواتير'),NavigationDestination(icon:Icon(Icons.people),label:'العملاء'),NavigationDestination(icon:Icon(Icons.inventory),label:'المنتجات'),NavigationDestination(icon:Icon(Icons.bar_chart),label:'التقارير')]));}}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<double>>(
      future: DatabaseHelper.instance.monthlySales(),
      builder: (context, snapshot) {
        final values = snapshot.data ?? List<double>.filled(6, 0);
        return ListView(padding: const EdgeInsets.all(16), children: [
          const Text('لوحة التحكم', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Wrap(spacing: 8, runSpacing: 8, children: [MetricCard('إجمالي المبيعات'), MetricCard('إجمالي المشتريات'), MetricCard('عدد العملاء'), MetricCard('صافي الربح')]),
          const SizedBox(height: 20),
          SizedBox(height: 220, child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: [for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])], isCurved: true)]))),
          const Text('مبيعات آخر 6 شهور', textAlign: TextAlign.center),
        ]);
      },
    );
  }
}
class MetricCard extends StatelessWidget{final String title;const MetricCard(this.title,{super.key});@override Widget build(BuildContext context)=>SizedBox(width:165,child:Card(child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.analytics,color:Color(0xFF0D47A1)),Text(title),const Text('0.00 ر.س',style:TextStyle(fontWeight:FontWeight.bold,color:Color(0xFF0D47A1)))]))));}

class InvoicesPage extends StatelessWidget{const InvoicesPage({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[FilledButton.icon(onPressed:()=>showDialog(context:context,builder:(_)=>const AlertDialog(title:Text('فاتورة جديدة'),content:TextField(decoration:InputDecoration(labelText:'المبلغ')),actions:[TextButton(onPressed:null,child:Text('حفظ'))])),icon:const Icon(Icons.add),label:const Text('فاتورة جديدة')),const SizedBox(height:12),const Card(child:ListTile(title:Text('لا توجد فواتير بعد')))]);}
class CustomersPage extends StatelessWidget{const CustomersPage({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[FilledButton.icon(onPressed:(){},icon:const Icon(Icons.person_add),label:const Text('إضافة عميل')),const Card(child:ListTile(title:Text('العملاء'),subtitle:Text('SQLite محلي')))]);}
class ProductsPage extends StatelessWidget{const ProductsPage({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[FilledButton.icon(onPressed:(){},icon:const Icon(Icons.add_box),label:const Text('إضافة صنف')),const Card(child:ListTile(title:Text('المنتجات والمخزون'),subtitle:Text('SQLite محلي')))]);}
class ReportsPage extends StatelessWidget{const ReportsPage({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[for(final x in['تقرير المبيعات','تقرير الأرباح والخسائر','كشف حساب عميل'])Card(child:ListTile(leading:const Icon(Icons.assessment),title:Text(x)))]);}
class SettingsPage extends StatelessWidget{const SettingsPage({super.key});@override Widget build(BuildContext context)=>ListView(children:[const ListTile(leading:Icon(Icons.business),title:Text('بيانات الشركة')),ListTile(leading:const Icon(Icons.print),title:const Text('طباعة فاتورة PDF'),onTap:()=>PdfService.printInvoice(number:'TEST-001',customer:'عميل',subtotal:100,tax:15,total:115)),const ListTile(leading:Icon(Icons.backup),title:Text('النسخ الاحتياطي')),const ListTile(leading:Icon(Icons.info),title:Text('حول التطبيق'))]);}
