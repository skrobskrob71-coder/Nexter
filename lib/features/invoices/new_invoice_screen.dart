import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/database/database_helper.dart';
import '../../core/services/pdf_service.dart';

class NewInvoiceScreen extends StatefulWidget { const NewInvoiceScreen({super.key}); @override State<NewInvoiceScreen> createState()=>_NewInvoiceScreenState(); }
class _NewInvoiceScreenState extends State<NewInvoiceScreen> {
  final customer=TextEditingController(); final amount=TextEditingController();
  Future<void> save(bool print) async { final subtotal=double.tryParse(amount.text)??0; if(subtotal<=0)return; final tax=subtotal*.15; final number='INV-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}'; await DatabaseHelper.instance.insert('invoices',{'number':number,'customer_name':customer.text,'subtotal':subtotal,'tax':tax,'total':subtotal+tax,'created_at':DateTime.now().toIso8601String()}); if(print){await PdfService.printInvoice(number:number,customer:customer.text,subtotal:subtotal,tax:tax,total:subtotal+tax);} if(mounted && !print)Navigator.pop(context); }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('فاتورة جديدة')),body:ListView(padding:const EdgeInsets.all(16),children:[TextField(controller:customer,decoration:const InputDecoration(labelText:'العميل',border:OutlineInputBorder())),const SizedBox(height:12),TextField(controller:amount,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'المبلغ قبل الضريبة',border:OutlineInputBorder())),const SizedBox(height:12),const Card(child:ListTile(title:Text('ضريبة القيمة المضافة'),trailing:Text('15%'))),const SizedBox(height:16),Row(children:[Expanded(child:FilledButton(onPressed:()=>save(false),child:const Text('حفظ'))),const SizedBox(width:8),Expanded(child:OutlinedButton(onPressed:()=>save(true),child:const Text('حفظ وطباعة PDF')))])]));
}
