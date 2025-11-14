
# Life Below Water+

Fitur:
- Onboarding (PageView, simpan status dengan shared_preferences)
- Mock Auth (Sign In / Sign Up) disimpan di shared_preferences
- Bottom Navigation (Sightings / Articles / Settings)
- SQLite CRUD `sightings` + StreamBuilder
- HTTP + JSON fetch contoh artikel
- Theme light/dark

## Menjalankan
```
flutter create .        # jika folder platform belum ada
flutter pub get
# Tambah izin internet Android:
# android/app/src/main/AndroidManifest.xml -> <uses-permission android:name="android.permission.INTERNET"/>
flutter run
```

Catatan: `sqflite` tidak berjalan di Web. Gunakan Android/iOS.
