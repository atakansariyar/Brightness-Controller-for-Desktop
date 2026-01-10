# Değişiklik Günlüğü

Masaüstü Parlaklık Denetleyicisi için tüm önemli değişiklikler.

## [2.1.0] - 2026-01-10

### Yeni Özellikler

- Hızlı Parlaklık Popup'ı - System tray ikonuna çift tıklayarak modern slider popup'ı açın
  - Parlaklığı ayarlamak için sürükleyin veya scroll yapın
- Çoklu Tuş Kısayol Yakalama - Modifier tuş kombinasyonları desteği
  - Ctrl+Alt+Tuş, Win+Shift+Tuş vb. yakalayın
- Yerelleştirilmiş Tray Menüsü - System tray menüsü seçilen dile çevrilir
- Doğrulamalı Config Yenileme - config.ini hatalıysa hata mesajı gösterir
- Bağımsız Kurulum Programı - `setup.exe` artık AutoHotkey gerektirmeden kurulum yapabilir
- Yüksek Öncelikli Başlangıç - Diğer uygulamalardan önce başlamak için Task Scheduler seçeneği
- Ayarlarda Başlangıç Modu - Başlangıç yapılandırmasını doğrudan Ayarlar'dan görüntüleyin ve doğrulayın
- OSD Popup Açma/Kapama - Ayarlarda Windows 11 tarzı popup'ı devre dışı bırakma seçeneği
- Kaldırma Aracı - `uninstall.exe` veya `uninstall.ahk` (AutoHotkey gerektirir) ile uygulamayı temiz bir şekilde kaldırma

---

## [2.0.0] - 2026-01-09

### Büyük Sürüm - Tamamen Yeniden Yazıldı

Tamamen yeniden yazılmış kod tabanı ve birçok yeni özellik içeren büyük bir güncelleme.

### Yeni Özellikler

- Ayarlar GUI - System tray'den erişilebilen tam grafik arayüz
- Çoklu Monitör Desteği
  - Tüm monitörler modu
  - İmleç konumu modu (yalnızca farenin bulunduğu monitörü ayarlar)
  - İndeksle belirli monitör seçimi
  - Windows'tan gerçek monitör isimleri (örn. "XG2405")
- Harici Yapılandırma - Ayarlar `config.ini` dosyasına kaydedilir
- Çoklu Dil Desteği - 5 dil: English, Türkçe, Русский, 中文, 日本語
- F-Tuşu Gönderici - Kısayol yakalama için F13-F24 sanal tuş gönderme aracı
- Kısayol Yakalama - "Yakala"ya tıklayın ve herhangi bir tuşa basarak atayın
- Kurulum Programı - Başlangıç kısayolu ile tek tıkla kurulum
- Özel System Tray İkonu - Kolay tanımlama için güneş ikonu
- Varsayılanlara Dön / Geri Al / Ayar Klasörünü Aç butonları

### Yeni Dosyalar

- `setup.ahk` - Kurulum script'i
- `brightness_icon.ico` - Özel tray ikonu
- `config.ini` - Yapılandırma dosyası (otomatik oluşturulur)

---

## [1.0.0] - İlk Sürüm

### Özellikler
- DDC/CI ile temel parlaklık kontrolü
- Windows 11 tarzı animasyonlu OSD popup
- Yapılandırılabilir kısayollar (varsayılan F13/F14)
- Yumuşak parlaklık geçişi
- Açık/Koyu tema algılama
