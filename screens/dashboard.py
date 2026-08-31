from kivy.uix.screenmanager import Screen
from kivy.properties import StringProperty
from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.boxlayout import BoxLayout

class DashboardScreen(Screen):
    title_text = StringProperty("لوحة التحكم")
    def refresh(self):
        data = App.get_running_app().db.dashboard()
        self.ids.sales.text = f"{data['sales']:,.2f} ر.س"
        self.ids.profit.text = f"{data['profit']:,.2f} ر.س"
        self.ids.expenses.text = f"{data['expenses']:,.2f} ر.س"
        self.ids.count.text = str(data['count'])
        self.ids.best_box.clear_widgets()
        for row in data["best"]:
            self.ids.best_box.add_widget(Label(text=f"{row['name']}   {row['total']:,.2f} ر.س", font_name="Cairo", color=(.04,.15,.25,1), size_hint_y=None, height=32))
