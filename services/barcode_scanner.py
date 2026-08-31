"""مكوّن مسح باركود بالكاميرا. يتطلب kivy_garden.zbarcam على Android."""
from kivy.uix.boxlayout import BoxLayout
from kivy.properties import ObjectProperty, StringProperty

try:
    from kivy_garden.zbarcam import ZBarCam
except ImportError:
    ZBarCam = None

class BarcodeScanner(BoxLayout):
    target_input = ObjectProperty(None)
    status = StringProperty("")
    camera = ObjectProperty(None)

    def __init__(self, target_input=None, **kwargs):
        super().__init__(orientation="vertical", **kwargs)
        self.target_input = target_input
        if ZBarCam is None:
            self.status = "مكوّن الكاميرا غير مثبت"
            return
        self.camera = ZBarCam()
        self.camera.bind(symbols=self._on_symbols)
        self.add_widget(self.camera)

    def _on_symbols(self, instance, symbols):
        if not symbols:
            return
        value = symbols[0].data.decode("utf-8", errors="replace")
        if self.target_input is not None:
            self.target_input.text = value
        self.status = f"تمت قراءة الباركود: {value}"

    def stop(self):
        if self.camera and hasattr(self.camera, "stop"):
            self.camera.stop()
