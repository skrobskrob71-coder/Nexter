# Nexter

**Nexter** هو تطبيق محاسبي عربي يعمل دون اتصال، مبني باستخدام Python وKivy وSQLite. يركز التصميم على الهوية الداكنة بالأزرق `#0A2540` مع الأخضر `#00C896`، وتحتوي الواجهة على شاشات لوحة التحكم، الفواتير، جهات التعامل، المخزون، التقارير والإعدادات.

## المتطلبات

يلزم Linux أو WSL مع Python 3، Java JDK، Android SDK/NDK، وBuildozer. يوصى باستخدام Ubuntu 22.04 أو 24.04. يتم تنزيل مكونات Android تلقائيًا عند أول بناء بواسطة python-for-android، لذلك قد يستغرق البناء الأول وقتًا طويلًا.

## التشغيل المكتبي

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install kivy==2.3.0 reportlab
python main.py
```

إذا لم يتوفر خط Cairo، يستخدم التطبيق ملف الخط الموجود في `assets/Cairo-Regular.ttf` لضمان ظهور العربية محليًا. يمكن استبداله بملف Cairo الرسمي مع الإبقاء على الاسم نفسه.

## بناء APK لأندرويد 14

```bash
sudo apt update
sudo apt install -y build-essential git zip unzip openjdk-17-jdk python3-pip autoconf libtool pkg-config zlib1g-dev libncurses5-dev libncursesw5-dev cmake libffi-dev libssl-dev
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install buildozer cython==0.29.36
buildozer android clean
buildozer -v android debug
```

سيظهر ملف APK داخل مجلد `bin/`. لإنشاء نسخة موقعة للإنتاج، استخدم إعدادات keystore الخاصة بك ثم نفّذ `buildozer android release`، وبعد ذلك وقّع الحزمة وفق سياسة التوزيع المستهدفة.

## بنية المشروع

| المسار | المسؤولية |
|---|---|
| `main.py` | تشغيل التطبيق، تهيئة قاعدة البيانات وإدارة التنقل |
| `nexter.kv` | تخطيط واجهة Kivy والهوية البصرية |
| `services/database.py` | SQLite، المخطط، المعاملات والاستعلامات |
| `screens/dashboard.py` | مؤشرات اليوم وأفضل العملاء |
| `screens/invoices.py` | إنشاء الفواتير وحساب ضريبة 15% |
| `screens/partners.py` | العملاء والموردون |
| `screens/inventory.py` | المنتجات والباركود وحد التنبيه |
| `screens/reports.py` | المبيعات والربح والضريبة وميزان المراجعة |
| `screens/settings.py` | بيانات الشركة والنسخ الاحتياطي |
| `buildozer.spec` | إعدادات حزمة Android API 34 وNDK 21e |

## قاعدة البيانات

ينشئ التطبيق تلقائيًا الجداول `users`, `products`, `customers`, `invoices`, `invoice_items`, و`expenses`، إضافة إلى فهارس للتواريخ والباركود. كل عملية كتابة تستخدم معاملة SQLite مع rollback تلقائي عند الخطأ. توجد قاعدة التشغيل في `data/nexter.db`، ويصدر زر النسخ الاحتياطي نسخة مستقلة بامتداد `.db` داخل مجلد `data`.

## ملاحظات هندسية

التطبيق مصمم Offline-first ولا يعتمد على خادم أو حساب سحابي. الفاتورة الحالية تسجل إجمالي الفاتورة وتفاصيل الضريبة تلقائيًا، بينما يسمح مخطط `invoice_items` بإضافة تفاصيل الأصناف عند توسيع شاشة الإدخال. يمكن إضافة الطباعة والمشاركة عبر Android intents في مرحلة التوزيع النهائية؛ أما ملف البناء الحالي فيتضمن جميع الاعتماديات المحلية الأساسية ويعمل دون اتصال بعد اكتمال أول عملية بناء.

## فحص سريع

```bash
python3 -m py_compile main.py services/database.py screens/*.py
```

الترخيص المقترح للمشروع يحدد من قبل مالك المنتج قبل التوزيع التجاري.

## تصدير التقارير إلى Excel

أضيفت الخدمة `services/excel_service.py`، وهي تنشئ ملف `.xlsx` متعدد الأوراق يضم المبيعات، المصروفات، المخزون، وملخصًا ماليًا. زر **تصدير التقارير إلى Excel** في شاشة التقارير يحفظ الملف داخل مجلد بيانات التطبيق الخاص بالنظام، وهو مناسب للتطبيقات التي تعمل دون اتصال. تعتمد الخدمة على `openpyxl`، وقد أضيفت الاعتمادية إلى `buildozer.spec`.

يمكن استدعاء التصدير برمجيًا مع فترة زمنية اختيارية:

```python
from services.excel_service import ExcelReportExporter
path = ExcelReportExporter(db).export_all(
    output_dir="/storage/emulated/0/Documents/Nexter",
    from_date="2026-01-01",
    to_date="2026-12-31",
)
```

## مسح الباركود بالكاميرا في Kivy

تمت إضافة `services/barcode_scanner.py` كمكوّن اختياري يعتمد على `kivy_garden.zbarcam` و`pyzbar`. الفكرة هي وضع عنصر `BarcodeScanner` داخل شاشة إدخال المنتج، وتمرير حقل الباركود إليه؛ عند اكتشاف رمز، يقرأ المكوّن `symbol.data` ويضع القيمة تلقائيًا في حقل الإدخال.

مثال دمج داخل شاشة Kivy مخصصة:

```python
from kivy.uix.popup import Popup
from services.barcode_scanner import BarcodeScanner


def open_barcode_camera(self):
    scanner = BarcodeScanner(target_input=self.ids.barcode)
    popup = Popup(title="مسح الباركود", content=scanner,
                  size_hint=(.95, .80), auto_dismiss=True)
    popup.open()
```

وفي ملف `buildozer.spec` يجب إبقاء الاعتماديات التالية وإذن الكاميرا:

```ini
requirements = python3,kivy==2.3.0,reportlab,openpyxl,pyzbar,kivy_garden.zbarcam
android.permissions = CAMERA,READ_EXTERNAL_STORAGE,WRITE_EXTERNAL_STORAGE
```

يُفضّل طلب إذن الكاميرا وقت التشغيل قبل فتح المكوّن، لأن Android 6 وما بعده يعتمد أذونات وقت التشغيل. يمكن تنفيذ ذلك عبر `android.permissions` أو `python-for-android`، مع التعامل مع حالة الرفض وإظهار رسالة للمستخدم. في بعض بيئات Buildozer قد لا يتوفر recipe جاهز لـ `kivy_garden.zbarcam`؛ عندها يجب تثبيت المكوّن في بيئة البناء أو إضافة recipe مخصص لـ ZBar، ثم اختبار الكاميرا على جهاز فعلي بدل الاعتماد على المحاكي. كما ينبغي إيقاف الكاميرا عند إغلاق Popup لتقليل استهلاك البطارية.

تسلسل التشغيل المقترح هو: طلب إذن `CAMERA`، فتح نافذة المسح، انتظار `symbols`، تعبئة حقل الباركود، إغلاق الكاميرا بعد القراءة، ثم البحث في جدول `products` عن الباركود وتعبئة اسم المنتج وسعره. يجب عدم اعتبار قيمة الباركود رقمًا؛ تخزن كنص حتى لا تضيع الأصفار البادئة.
