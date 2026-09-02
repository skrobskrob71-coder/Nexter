import 'package:flutter/material.dart';
import 'home/dashboard_screen.dart';
import 'invoices/invoices_screen.dart';
import 'customers/customers_screen.dart';
import 'products_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget{const MainScreen({super.key});@override State<MainScreen> createState()=>_MainState();}
class _MainState extends State<MainScreen>{int selected=0;final pages=const[DashboardScreen(),InvoicesScreen(),CustomersScreen(),ProductsScreen(),ReportsScreen()];final titles=const['لوحة التحكم','الفواتير','العملاء','المنتجات','التقارير'];@override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(titles[selected]),actions:[const Padding(padding:EdgeInsets.all(12),child:Icon(Icons.account_balance))]),drawer:Drawer(child:ListView(children:[const DrawerHeader(decoration:BoxDecoration(color:Color(0xFF0D47A1)),child:Center(child:Text('ناكستر Naxter',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.bold)))),for(int i=0;i<titles.length;i++)ListTile(leading:Icon([Icons.dashboard,Icons.receipt_long,Icons.people,Icons.inventory_2,Icons.bar_chart][i]),title:Text(titles[i]),selected:selected==i,onTap:(){setState(()=>selected=i);Navigator.pop(c);}),const Divider(),ListTile(leading:const Icon(Icons.settings),title:const Text('الإعدادات'),onTap:(){Navigator.pop(c);Navigator.push(c,MaterialPageRoute(builder:(_)=>const SettingsScreen()));})])),body:pages[selected],bottomNavigationBar:BottomNavigationBar(currentIndex:selected,onTap:(i)=>setState(()=>selected=i),type:BottomNavigationBarType.fixed,selectedItemColor:const Color(0xFF0D47A1),items:const[BottomNavigationBarItem(icon:Icon(Icons.dashboard_outlined),label:'الرئيسية'),BottomNavigationBarItem(icon:Icon(Icons.receipt_long),label:'الفواتير'),BottomNavigationBarItem(icon:Icon(Icons.people_outline),label:'العملاء'),BottomNavigationBarItem(icon:Icon(Icons.inventory_2_outlined),label:'المنتجات'),BottomNavigationBarItem(icon:Icon(Icons.bar_chart),label:'التقارير')])));}
}
