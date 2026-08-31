from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App
from services.excel_service import ExcelReportExporter
from pathlib import Path

class ReportsScreen(Screen):
    title_text = StringProperty("التقارير")
    def refresh(self):
        db=App.get_running_app().db
        sales=db.one("SELECT COALESCE(SUM(total),0) v FROM invoices WHERE kind='sale'")["v"]
        tax=db.one("SELECT COALESCE(SUM(tax),0) v FROM invoices WHERE kind='sale'")["v"]
        expenses=db.one("SELECT COALESCE(SUM(amount),0) v FROM expenses")["v"]
        self.ids.report.text=(f"إجمالي المبيعات: {sales:,.2f} ر.س\nإجمالي ضريبة المخرجات: {tax:,.2f} ر.س\nإجمالي المصروفات: {expenses:,.2f} ر.س\nصافي الربح التقديري: {sales-expenses:,.2f} ر.س\n\nميزان المراجعة\nمدين المبيعات: {sales:,.2f}\nدائن المصروفات: {expenses:,.2f}")
    def export_excel(self):
        try:
            path=ExcelReportExporter(App.get_running_app().db).export_all(str(Path(App.get_running_app().user_data_dir) / "reports"))
            self.ids.export_message.text=f"تم تصدير Excel: {Path(path).name}"
        except Exception as exc:
            self.ids.export_message.text=f"تعذر تصدير Excel: {exc}"
