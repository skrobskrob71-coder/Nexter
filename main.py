"""Nexter - تطبيق محاسبي عربي يعمل دون اتصال.
واجهة التشغيل الرئيسية وإدارة التنقل بين وحدات التطبيق.
"""
from kivy.config import Config
Config.set("graphics", "width", "400")
Config.set("graphics", "height", "760")
Config.set("kivy", "exit_on_escape", "0")

from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, FadeTransition
from kivy.core.text import LabelBase
from kivy.core.window import Window
from kivy.resources import resource_add_path
from pathlib import Path

from services.database import Database
from screens.dashboard import DashboardScreen
from screens.invoices import InvoicesScreen
from screens.partners import PartnersScreen
from screens.inventory import InventoryScreen
from screens.reports import ReportsScreen
from screens.settings import SettingsScreen

BASE_DIR = Path(__file__).resolve().parent
KV_FILE = BASE_DIR / "app.kv"

class NexterApp(App):
    title = "Nexter"
    db = None
    theme = {"navy": "#0A2540", "green": "#00C896", "white": "#F7FAFC", "muted": "#6B7280", "bg": "#F3F6F9"}

    def build(self):
        self.db = Database(str(BASE_DIR / "data" / "nexter.db"))
        self.db.initialize()
        if (BASE_DIR / "assets").exists():
            resource_add_path(str(BASE_DIR / "assets"))
        try:
            LabelBase.register(name="Cairo", fn_regular=str(BASE_DIR / "assets" / "Cairo-Regular.ttf"))
        except Exception:
            pass
        Builder.load_file(str(KV_FILE))
        manager = ScreenManager(transition=FadeTransition(duration=.12))
        for screen in (DashboardScreen(), InvoicesScreen(), PartnersScreen(), InventoryScreen(), ReportsScreen(), SettingsScreen()):
            manager.add_widget(screen)
        return manager

    def go(self, name):
        self.root.current = name
        screen = self.root.get_screen(name)
        if hasattr(screen, "refresh"):
            screen.refresh()

    def on_stop(self):
        if self.db:
            self.db.close()

if __name__ == "__main__":
    Window.clearcolor = (0.953, 0.965, 0.976, 1)
    NexterApp().run()

# مؤقتًا: إعادة تصدير الاسم للتوافق مع أدوات الاختبار
AppMain = NexterApp
