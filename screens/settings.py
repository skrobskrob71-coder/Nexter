from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App
from pathlib import Path
import shutil
from datetime import datetime

class SettingsScreen(Screen):
    title_text = StringProperty("الإعدادات")
    def backup(self):
        try:
            source=Path(App.get_running_app().db.path); target=source.parent / f"nexter_backup_{datetime.now():%Y%m%d_%H%M%S}.db"
            shutil.copy2(source,target); self.ids.message.text=f"تم تصدير النسخة الاحتياطية: {target.name}"
        except Exception as exc: self.ids.message.text=f"تعذر إنشاء النسخة: {exc}"
    def save_company(self):
        app=App.get_running_app(); db=app.db
        db.execute("CREATE TABLE IF NOT EXISTS settings(key TEXT PRIMARY KEY,value TEXT)")
        for key, field in (("company_name",self.ids.company),("tax_number",self.ids.tax)):
            db.execute("INSERT OR REPLACE INTO settings(key,value) VALUES(?,?)",(key,field.text))
        self.ids.message.text="تم حفظ بيانات الشركة"
    def refresh(self): pass
