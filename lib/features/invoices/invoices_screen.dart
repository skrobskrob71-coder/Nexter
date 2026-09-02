import 'package:flutter/material.dart';
import '../../core/database/database_helper.dart';
import '../../core/services/pdf_service.dart';
import 'new_invoice_screen.dart';

class InvoicesScreen extends StatefulWidget { const InvoicesScreen({super.key}); @override State<InvoicesScreen> createState()=>_InvoicesScreenState(); }
class _InvoicesScreenState extends State<InvoicesScreen> {
  Future<void> refresh() async { setState(() {}); }
  @override Widget build(BuildContext context) => FutureBuilder<List<Map<String,dynamic>>>(future:DatabaseHelper.instance.all('invoices'),builder:(context,snapshot){ final rows=snapshot.data??[]; return ListView(padding:const EdgeInsets.all(12),children:[Align(alignment:Alignment.centerLeft,child:FilledButton.icon(onPressed:()async{await Navigator.push(context,MaterialPageRoute(builder:(_)=>const NewInvoiceScreen()));refresh();},icon:const Icon(Icons.add),label:const Text('فاتورة جديدة'))),const SizedBox(height:12),if(rows.isEmpty)const Center(child:Padding(padding:EdgeInsets.all(30),child:Text('لا توجد فواتير'))),if(rows.isNotEmpty)SingleChildScrollView(scrollDirection:Axis.horizontal,child:DataTable(columns:const[DataColumn(label:Text('الرقم')),DataColumn(label:Text('العميل')),DataColumn(label:Text('التاريخ')),DataColumn(label:Text('الإجمالي')),DataColumn(label:Text('إجراءات'))],rows:rows.map((r)=>DataRow(cells:[DataCell(Text('${r['number']}')),DataCell(Text('${r['customer_name']??''}')),DataCell(Text('${r['created_at']}'.split('T').first)),DataCell(Text('${r['total']} ر.س')),DataCell(Row(children:[IconButton(onPressed:()=>PdfService.printInvoice(number:'${r['number']}',customer:'${r['customer_name']??''}',subtotal:r['subtotal'] as num,tax:r['tax'] as num,total:r['total'] as num),icon:const Icon(Icons.print,color:Colors.blue)),IconButton(onPressed:()async{await DatabaseHelper.instance.delete('invoices',r['id'] as int);refresh();},icon:const Icon(Icons.delete,color:Colors.red))]))])).toList())]); });
}
