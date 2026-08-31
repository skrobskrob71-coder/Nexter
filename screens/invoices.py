from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App
from datetime import datetime

class InvoicesScreen(Screen):
    title_text = StringProperty("الفواتير")
    def save_invoice(self):
        app = App.get_running_app(); db = app.db
        try:
            subtotal = float(self.ids.subtotal.text or 0)
            tax = round(subtotal * 0.15, 2)
            number = f"INV-{datetime.now():%Y%m%d%H%M%S}"
            db.execute("INSERT INTO invoices(number,kind,subtotal,tax,total,paid,issued_at,notes) VALUES(?,?,?,?,?,?,?,?)", (number,"sale",subtotal,tax,subtotal+tax,subtotal+tax,datetime.now().isoformat(timespec="seconds"),self.ids.notes.text))
            self.ids.message.text = f"تم حفظ الفاتورة {number} — الإجمالي {subtotal+tax:,.2f} ر.س"
            self.ids.subtotal.text = ""
        except (ValueError, TypeError) as exc:
            self.ids.message.text = f"تحقق من قيمة الفاتورة: {exc}"
    def refresh(self):
        self.ids.invoice_list.text = "\n".join(f"{r['number']} | {r['total']:,.2f} ر.س | {r['issued_at'][:10]}" for r in App.get_running_app().db.query("SELECT number,total,issued_at FROM invoices ORDER BY id DESC LIMIT 20")) or "لا توجد فواتير بعد"
