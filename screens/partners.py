from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App

class PartnersScreen(Screen):
    title_text = StringProperty("العملاء والموردون")
    def save_partner(self):
        name = self.ids.partner_name.text.strip()
        if not name:
            self.ids.message.text = "اكتب اسم العميل أو المورد أولًا"; return
        App.get_running_app().db.execute("INSERT INTO customers(name,phone,kind) VALUES(?,?,?)", (name,self.ids.phone.text,"customer"))
        self.ids.message.text = "تمت إضافة جهة التعامل بنجاح"; self.ids.partner_name.text=""; self.ids.phone.text=""; self.refresh()
    def refresh(self):
        rows = App.get_running_app().db.query("SELECT name,phone,kind FROM customers ORDER BY id DESC LIMIT 50")
        self.ids.partner_list.text = "\n".join(f"{r['name']} | {r['phone'] or 'بدون هاتف'}" for r in rows) or "لا توجد جهات تعامل بعد"
