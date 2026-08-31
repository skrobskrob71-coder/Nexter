[app]
# Nexter - Offline Arabic Accounting App
title = Nexter
package.name = nexter
package.domain = org.skrob
source.dir = .
source.include_exts = py,kv,png,jpg,jpeg,ttf,db,svg
source.exclude_dirs = .git,bin,venv,__pycache__,reports,data
version = 1.0.0
requirements = python3,kivy==2.3.0
orientation = portrait
fullscreen = 0
android.api = 34
android.minapi = 23
android.ndk = 25b
android.archs = arm64-v8a,armeabi-v7a
android.accept_sdk_license = True
android.permissions = CAMERA,READ_EXTERNAL_STORAGE,WRITE_EXTERNAL_STORAGE
android.private_storage = True
android.presplash_color = #0A2540

[buildozer]
log_level = 2
warn_on_root = 1

[app:android]
android.entrypoint = org.kivy.android.PythonActivity
android.allow_backup = True
android.uses_cleartext_traffic = False
