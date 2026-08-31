# Nexter

Nexter هو تطبيق محاسبي عربي يعمل دون اتصال باستخدام Python وKivy وSQLite. يتضمن المشروع ملفات التشغيل الأساسية `main.py` و`app.kv` و`database.py` ومجلد `assets` وملف `requirements.txt`، بالإضافة إلى وحدات الفواتير والمخزون والتقارير وتصدير Excel وPDF.

## تشغيل Kivy وبناء APK

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main.py
```

لبناء APK الخاص بتطبيق Kivy استخدم Buildozer، وليس EAS:

```bash
pip install buildozer cython==0.29.36
buildozer -v android debug
```

إعداد Android موجود في `buildozer.spec` ويستخدم API 34 وNDK 21e.

## ملفات Expo وEAS

تمت إضافة `app.json` و`eas.json` بالقيم المطلوبة. لكن **EAS Build خدمة بناء لمشاريع Expo/React Native، ولا تبني تطبيق Python/Kivy من `main.py` أو `requirements.txt`**. لذلك فإن تنفيذ `eas build -p android --profile preview` على هذا المستودع لن ينتج APK لتطبيق Nexter Kivy ما لم تتم إضافة تطبيق Expo/React Native مستقل أو إعداد بناء مخصص يحول Kivy إلى Android داخل صورة بناء مخصصة. المسار الصحيح لتطبيق Kivy هو Buildozer/python-for-android.

## Excel والباركود

توجد خدمة `services/excel_service.py` لتصدير أوراق المبيعات والمصروفات والمخزون والملخص إلى XLSX، وخدمة `services/barcode_scanner.py` لمسح الباركود اختياريًا عبر `kivy_garden.zbarcam`. يجب اختبار إذن الكاميرا على جهاز Android فعلي.

## تنبيه حول requirements.txt

السطر `sqlite3` موجود تلبيةً للمواصفة المطلوبة، لكنه جزء مدمج داخل Python وليس حزمة pip مستقلة؛ لذلك قد يتجاهله pip أو يرفض تثبيته. عند حدوث ذلك استخدم تثبيت بقية المتطلبات فقط، مع إبقاء `sqlite3` في الملف التوثيقي حسب الطلب.
