# Değişiklik Günlüğü

Desktop Brightness Controller için tüm önemli değişiklikler.

## [2.0.0] - 2026-01-09

### Büyük Sürüm - Tamamen Yeniden Yazıldı

Tamamen yeniden yazılmış kod tabanı ve birçok yeni özellik içeren büyük bir güncelleme.

### Yeni Özellikler

- **Ayarlar GUI** - Sistem tepsisinden erişilebilen tam grafik arayüz
- **Çoklu Monitör Desteği**
  - Tüm monitörler modu
  - İmleç konumu modu (yalnızca farenin bulunduğu monitörü ayarlar)
  - İndeksle belirli monitör seçimi
  - Windows'tan gerçek monitör isimleri (örn. "XG2405")
- **Harici Yapılandırma** - Ayarlar `config.ini` dosyasına kaydedilir
- **Çoklu Dil Desteği** - 5 dil:
  - English
  - Türkçe
  - Русский
  - 中文
  - 日本語
- **F-Tuşu Gönderici** - Kısayol yakalama için F13-F24 sanal tuş gönderme aracı
- **Kısayol Yakalama** - "Yakala"ya tıklayın ve herhangi bir tuşa basarak atayın
- **Kurulum Programı** - Tek tıkla kurulum:
  - Program Files'a otomatik kopyalama
  - İsteğe bağlı Windows başlangıç kısayolu
  - Özel ikon uygulaması
- **Özel Sistem Tepsisi İkonu** - Güneş ikonu
- **Varsayılanlara Dön** - Tek tıkla fabrika ayarlarına sıfırlama
- **Geri Al** - Kaydedilmemiş değişiklikleri geri al
- **Config Klasörünü Aç** - Yapılandırma dosyasına hızlı erişim

### Yeni Dosyalar

- `setup.ahk` - Kurulum script'i
- `brightness_icon.ico` - Özel tepsi ikonu
- `config.ini` - Yapılandırma dosyası (otomatik oluşturulur)

---

## [1.0.0] - İlk Sürüm

### Özellikler
- DDC/CI ile temel parlaklık kontrolü
- Windows 11 tarzı animasyonlu OSD popup
- Yapılandırılabilir kısayollar (varsayılan F13/F14)
- Yumuşak parlaklık geçişi
- Açık/Koyu tema algılama
