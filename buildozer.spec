[app]
title = Nexter
package.name = nexter
package.domain = org.skrob
source.dir =.
source.include_exts = py,kv,png,jpg,db
version = 1.0.0
requirements = python3,kivy==2.2.1,kivymd==1.1.1,pillow,sqlite3
orientation = portrait
android.api = 34
android.minapi = 24
android.archs = arm64-v8a
android.gradle_dependencies = androidx.appcompat:appcompat:1.6.1

[app:android]
android.sdk_path = /home/runner/.buildozer/android/platform/android-sdk
