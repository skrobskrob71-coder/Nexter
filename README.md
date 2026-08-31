# ناكستر | Nakster

تطبيق محاسبي Flutter عربي يعمل دون اتصال، بواجهة RTL وثيم Material 3 أزرق محاسبي، وقاعدة SQLite محلية للفواتير والعملاء والمنتجات والمصروفات.

## الصفحات

يبدأ التطبيق بشاشة Splash ثم Login، وبعد تسجيل الدخول يعرض لوحة التحكم بأربع بطاقات للمبيعات والمشتريات والرصيد والربح. يتضمن كذلك الفواتير مع حساب ضريبة 15% وجدول الفواتير، والعملاء مع الإضافة والتعديل والحذف، والمنتجات مع الكمية والسعر، والتقارير، والإعدادات والنسخ الاحتياطي.

## التشغيل والبناء

```bash
flutter pub get
flutter create --project-name=nakster --platforms=android --org=org.nakster .
flutter analyze
flutter build apk --release --shrink
flutter build appbundle --release
```

ينتج APK في `build/app/outputs/flutter-apk/app-release.apk` وApp Bundle في `build/app/outputs/bundle/release/app-release.aab`.

## GitHub Actions

يوجد Workflow في `.github/workflows/flutter.yml` يعمل عند الدفع إلى `main` أو يدويًا، وينفذ التحليل ثم يبني APK release مع `--shrink` وApp Bundle، ويرفعهما كـ artifacts باسمَي `Nakster-release-apk` و`Nakster-release-aab`.

## البنية

| المسار | الوظيفة |
|---|---|
| `lib/main.dart` | التطبيق والواجهات والتنقل |
| `lib/data/app_database.dart` | SQLite والجداول والاستعلامات |
| `pubspec.yaml` | حزم Flutter وخط Cairo |
| `assets/Cairo-Regular.ttf` | الخط العربي المضمّن |
| `.github/workflows/flutter.yml` | البناء التلقائي |

لضمان حجم APK صغير، يستخدم البناء release مع `--shrink`، ومعمارية Android الافتراضية المجمعة في APK الواحد. يمكن استخدام `--split-per-abi` لاحقًا للحصول على ملفات أصغر لكل معمارية.
