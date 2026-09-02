import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> printInvoice({required String number,required String customer,required num subtotal,required num tax,required num total}) async {
    final fontData=await rootBundle.load('assets/Cairo-Regular.ttf');
    final font=pw.Font.ttf(fontData);
    final doc=pw.Document(theme:pw.ThemeData.withFont(base:font,bold:font));
    doc.addPage(pw.Page(pageFormat:PdfPageFormat.a4,build:(_)=>pw.Directionality(textDirection:pw.TextDirection.rtl,child:pw.Padding(padding:const pw.EdgeInsets.all(28),child:pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.stretch,children:[pw.Text('ناكستر Naxter',style:pw.TextStyle(font:font,fontSize:24,fontWeight:pw.FontWeight.bold,color:PdfColors.blue900)),pw.SizedBox(height:18),pw.Text('فاتورة ضريبية',style:pw.TextStyle(font:font,fontSize:18)),pw.SizedBox(height:10),pw.Text('رقم الفاتورة: $number',style:pw.TextStyle(font:font)),pw.Text('العميل: ${customer.isEmpty?'نقدي':customer}',style:pw.TextStyle(font:font)),pw.Divider(),pw.SizedBox(height:12),pw.Row(mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,children:[pw.Text('المجموع قبل الضريبة',style:pw.TextStyle(font:font)),pw.Text('${subtotal.toStringAsFixed(2)} ر.س',style:pw.TextStyle(font:font))]),pw.Row(mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,children:[pw.Text('ضريبة القيمة المضافة 15%',style:pw.TextStyle(font:font)),pw.Text('${tax.toStringAsFixed(2)} ر.س',style:pw.TextStyle(font:font))]),pw.Divider(),pw.Row(mainAxisAlignment:pw.MainAxisAlignment.spaceBetween,children:[pw.Text('الإجمالي',style:pw.TextStyle(font:font,fontWeight:pw.FontWeight.bold)),pw.Text('${total.toStringAsFixed(2)} ر.س',style:pw.TextStyle(font:font,fontWeight:pw.FontWeight.bold))]),pw.Spacer(),pw.Center(child:pw.Text('شكرًا لتعاملكم معنا',style:pw.TextStyle(font:font)))]))));
    await Printing.layoutPdf(onLayout:(_)=>doc.save(),name:'$number.pdf');
  }
}
