# ناكستر Naxter

تطبيق محاسبي Flutter عربي يعمل دون اتصال، بواجهة RTL كاملة، ثيم Material 3 أزرق محاسبي، وقاعدة SQLite محلية للفواتير والعملاء والمنتجات وبنود الفواتير.

## الصفحات

يبدأ التطبيق بشاشة Splash لمدة ثلاث ثوانٍ، ثم Login، وبعدها MainScreen تحتوي Drawer وBottomNavigationBar بخمسة تبويبات: لوحة التحكم، الفواتير، العملاء، المنتجات، والتقارير. الإعدادات متاحة من الـ Drawer.

تحتوي لوحة التحكم على بطاقات المبيعات والمشتريات وعدد العملاء وصافي الربح، ورسم بياني/ملخص آخر الفواتير. توفر شاشة الفواتير إضافة فاتورة وحساب ضريبة 15% وجدولًا للحذف والطباعة. توفر شاشة العملاء الإضافة والتعديل والحذف والبحث، وتوفر شاشة المنتجات الباركود والكمية وسعر الشراء وسعر البيع.

## البنية

| المسار | الوظيفة |
|---|---|
| `lib/features/splash/splash_screen.dart` | شاشة البداية |
| `lib/features/auth/login_screen.dart` | تسجيل الدخول |
| `lib/features/main_screen.dart` | Drawer وBottomNavigationBar |
| `lib/features/home/dashboard_screen.dart` | لوحة المؤشرات والملخص |
| `lib/features/invoices/` | الفواتير وإضافة فاتورة |
| `lib/features/customers/customers_screen.dart` | CRUD العملاء والبحث |
| `lib/features/products_screen.dart` | إدارة المنتجات والمخزون |
| `lib/features/reports_screen.dart` | التقارير المالية |
| `lib/features/settings_screen.dart` | الإعدادات والنسخ الاحتياطي |
| `lib/core/database/database_helper.dart` | SQLite والجداول والاستعلامات |
| `lib/core/services/pdf_service.dart` | إنشاء وطباعة PDF |

## التشغيل والبناء

```bash
flutter pub get
flutter create --project-name=naxter --platforms=android --org=com.naxter .
flutter analyze
flutter build apk --release
flutter build appbundle --release
```

يتم إنشاء APK في `build/app/outputs/flutter-apk/app-release.apk` وApp Bundle في `build/app/outputs/bundle/release/app-release.aab`.

## GitHub Actions

يشغّل `.github/workflows/build.yml` أوتوماتيكيًا عند الدفع إلى `main` أو يدويًا من تبويب Actions. ينفذ `flutter pub get`، و`flutter analyze`، ثم `flutter build apk --release` و`flutter build appbundle --release`، ويرفع الناتجين كـ Artifacts باسم `Naxter-Release`.
