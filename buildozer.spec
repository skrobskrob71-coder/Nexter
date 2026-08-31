[app]
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
android.minapi = 24
android.ndk = 25b
android.archs = arm64-v8a
android.accept_sdk_license = True
android.private_storage = True

[buildozer]
log_level = 2
warn_on_root = 0
