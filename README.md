# Nexter Flutter

Nexter تطبيق محاسبي عربي يعمل دون اتصال، مبني الآن باستخدام Flutter وSQLite المحلي عبر `sqflite`. تم حذف مسار Kivy/Buildozer القديم لأنه كان سبب بطء وفشل البناء، وأصبح البناء يتم مباشرة عبر Flutter وGitHub Actions.

## التشغيل المحلي

ثبّت Flutter 3.24 أو أحدث، ثم نفّذ:

```bash
flutter pub get
flutter create --platforms=android --org=org.skrob .
flutter run
```

## بناء APK

```bash
flutter pub get
flutter analyze
flutter build apk --release
```

سيظهر الملف في:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## GitHub Actions

يعمل Workflow الموجود في `.github/workflows/flutter.yml` عند الدفع إلى `main` أو يدويًا من تبويب Actions. ينفذ إنشاء مشروع Android، تنزيل الحزم، التحليل، ثم `flutter build apk --release` ويرفع APK كـ artifact باسم `Nexter-flutter-release-apk`.

## البنية

| المسار | الوظيفة |
|---|---|
| `lib/main.dart` | التطبيق والواجهات والتنقل وقاعدة SQLite المحلية |
| `pubspec.yaml` | حزم Flutter المطلوبة |
| `.github/workflows/flutter.yml` | البناء التلقائي ورفع APK |
| `assets/logo.svg` | هوية Nexter البصرية |
| `app.json` و`eas.json` | ملفات Expo محفوظة للتوافق، لكنها ليست مسار بناء Flutter |

## ملاحظة مهمة

هذا الإصدار يستخدم Flutter بدل Python/Kivy؛ لذلك لم يعد `buildozer.spec` أو `requirements.txt` أو ملفات Python القديمة جزءًا من مسار البناء. قاعدة البيانات تنشأ تلقائيًا على الهاتف، وتوجد الجداول الأساسية للفواتير والمنتجات والمصروفات.
