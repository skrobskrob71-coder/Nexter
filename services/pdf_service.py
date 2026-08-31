"""إنشاء مستندات PDF للفواتير باستخدام ReportLab، مع دعم اتجاه النص الأساسي."""
from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm
from datetime import datetime


def create_invoice_pdf(output_dir, invoice_number, lines, subtotal, tax_rate=15, company_name="Nexter"):
    output = Path(output_dir); output.mkdir(parents=True, exist_ok=True)
    path = output / f"{invoice_number}.pdf"
    total = subtotal + subtotal * tax_rate / 100
    pdf = canvas.Canvas(str(path), pagesize=A4)
    width, height = A4
    pdf.setFillColorRGB(0.04, 0.145, 0.25)
    pdf.rect(0, height-32*mm, width, 32*mm, fill=1, stroke=0)
    pdf.setFillColorRGB(0, 0.78, 0.59)
    pdf.setFont("Helvetica-Bold", 20)
    pdf.drawRightString(width-18*mm, height-19*mm, company_name)
    pdf.setFillColorRGB(0.04, 0.145, 0.25)
    pdf.setFont("Helvetica-Bold", 14)
    pdf.drawRightString(width-18*mm, height-48*mm, "فاتورة ضريبية")
    pdf.setFont("Helvetica", 10)
    pdf.drawRightString(width-18*mm, height-56*mm, f"{invoice_number}  |  {datetime.now():%Y-%m-%d}")
    y = height - 78*mm
    pdf.setFont("Helvetica-Bold", 10)
    pdf.drawRightString(width-18*mm, y, "الوصف"); pdf.drawString(90*mm, y, "الكمية"); pdf.drawString(125*mm, y, "السعر"); pdf.drawString(165*mm, y, "الإجمالي")
    y -= 8*mm; pdf.setFont("Helvetica", 10)
    for line in lines:
        pdf.drawRightString(width-18*mm, y, str(line.get("description", "")))
        pdf.drawString(90*mm, y, str(line.get("quantity", 1)))
        pdf.drawString(125*mm, y, f"{float(line.get('unit_price', 0)):,.2f}")
        pdf.drawString(165*mm, y, f"{float(line.get('line_total', 0)):,.2f}")
        y -= 7*mm
    y -= 8*mm
    pdf.drawRightString(width-18*mm, y, f"المجموع: {subtotal:,.2f} ر.س")
    y -= 7*mm; pdf.drawRightString(width-18*mm, y, f"الضريبة ({tax_rate:g}%): {subtotal*tax_rate/100:,.2f} ر.س")
    y -= 9*mm; pdf.setFont("Helvetica-Bold", 12); pdf.drawRightString(width-18*mm, y, f"الإجمالي: {total:,.2f} ر.س")
    pdf.save(); return str(path)
