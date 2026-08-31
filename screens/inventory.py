from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App

class InventoryScreen(Screen):
    title_text = StringProperty("المنتجات والمخزون")
    def save_product(self):
        try:
            name = self.ids.product_name.text.strip(); qty=float(self.ids.qty.text or 0); price=float(self.ids.price.text or 0); minimum=float(self.ids.minimum.text or 0)
            if not name: raise ValueError("اسم المنتج مطلوب")
            App.get_running_app().db.execute("INSERT INTO products(name,barcode,quantity,sale_price,min_quantity) VALUES(?,?,?,?,?)", (name,self.ids.barcode.text,qty,price,minimum))
            self.ids.message.text = "تم حفظ المنتج"; self.refresh()
        except Exception as exc:
            self.ids.message.text = f"تعذر الحفظ: {exc}"
    def refresh(self):
        rows=App.get_running_app().db.query("SELECT name,quantity,unit,sale_price,min_quantity FROM products ORDER BY id DESC")
        self.ids.product_list.text="\n".join(f"{r['name']} | {r['quantity']:g} {r['unit']} | {r['sale_price']:,.2f} ر.س" + ("  ⚠ نقص" if r['quantity']<=r['min_quantity'] else "") for r in rows) or "لا توجد منتجات بعد"
