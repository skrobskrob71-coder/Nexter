import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfService {
  static Future<void> printInvoice({required String number, required String customer, required num subtotal, required num tax, required num total}) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(pageFormat: PdfPageFormat.a4, build: (context) {
      return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.stretch, children: [
        pw.Text('Naxter - Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 20),
        pw.Text('Invoice: $number'),
        pw.Text('Customer: ${customer.isEmpty ? 'Cash' : customer}'),
        pw.Divider(),
        pw.Text('Subtotal: ${subtotal.toStringAsFixed(2)}'),
        pw.Text('VAT 15%: ${tax.toStringAsFixed(2)}'),
        pw.Divider(),
        pw.Text('Total: ${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ]);
    }));
    await Printing.layoutPdf(onLayout: (format) => doc.save(), name: '$number.pdf');
  }
}
