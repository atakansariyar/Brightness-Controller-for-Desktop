# <img src="assets/brightness_icon.png" width="32" height="32"> Masaüstü Parlaklık Denetleyicisi

Dış monitörünüzün parlaklığını klavye kısayollarıyla kontrol edin - Windows 11 tarzı OSD ile.

![Demo](assets/demo.gif)

## Özellikler

- Dış monitörler için DDC/CI parlaklık kontrolü
- Windows 11 tarzı animasyonlu OSD popup
- System tray çift tıkla ile hızlı parlaklık popup'ı
- Çoklu monitör desteği (tümü / imleç konumu / belirli monitör)
- Çoklu tuş desteği (Ctrl+Alt+Tuş kombinasyonları)
- Ayarlar GUI'si ile özelleştirilebilir kısayollar
- Klavye makro entegrasyonu için F-Tuşu Gönderici
- Çoklu dil: English, Türkçe, Русский, 中文, 日本語
- System tray entegrasyonu

## Gereksinimler

- Windows 10/11
- DDC/CI destekli dış monitör
- AutoHotkey v2.0 (sadece .ahk sürümü için)

## Kurulum

### Setup ile
1. `setup.exe` veya `setup.ahk` (AutoHotkey gerekli) dosyasını yönetici olarak çalıştırın
2. Kurulum tipini seçin (AHK veya EXE)
3. Windows başlangıcına eklenip eklenmeyeceğini seçin

Kolay kurulum ve maksimum uyumluluk için EXE sürümünü kullanın. Özelleştirme yapmak isterseniz, indirdiğiniz `brightness_control.exe` dosyasını silip `brightness_control.ahk` dosyasını kendiniz derleyerek kendi EXE'nizi oluşturabilirsiniz.

### Manuel
1. Dosyaları istediğiniz konuma kopyalayın
2. `brightness_control.exe` çalıştırın (veya `.ahk` için AutoHotkey ile çalıştırın)

## Hızlı Parlaklık Popup'ı

Hızlı parlaklık slider'ı açmak için system tray'deki uygulama ikonuna çift tıklayın:

![Popup Slider](assets/popup.png)

- Parlaklığı ayarlamak için sürükleyin
- İnce ayar için herhangi bir yerde scroll yapın
- Kapatmak için dışarı tıklayın

## System Tray Menüsü

Menüye erişmek için system tray'deki uygulama ikonuna sağ tıklayın:

- Ayarlar - Ayarlar penceresini açar
- Config'i Yenile - config.ini ayarlarını programa uygular
- Çıkış - Uygulamayı kapatır

**İpucu:** OSD bildirim popup'ını Ayarlar'da "OSD Popup'u Etkinleştir" seçeneğinden kapatabilirsiniz.

## Kısayol Yapılandırması

Kısayolları yapılandırmak için system tray'deki uygulama ikonuna sağ tıklayın ve Ayarlar'ı seçin:

![Ayarlar](assets/settings.png)

1. Herhangi bir kısayol alanının yanındaki Yakala butonuna tıklayın
2. İstediğiniz kombinasyon tuşlarına basın
3. Uygulamak ve yeniden başlatmak için Kaydet'e tıklayın

Çoklu tuş örnekleri: `Win+Ctrl+Up`, `Alt+F13`, `Ctrl+Shift+PageUp`

## Manuel Config Düzenleme

Eğer isterseniz `config.ini` dosyasını manuel olarak düzenleyebilirsiniz:

1. System tray ikonuna sağ tıklayın → Ayarlar'da Config Klasörünü Aç
2. `config.ini` dosyasını bir metin editöründe düzenleyin
3. System tray ikonuna sağ tıklayın → Config'i Yenile ile değişiklikleri uygulayın

Not: C:\ klasöründeki config dosyasını düzenleyemiyorsanız, dosyayı masaüstüne kopyalayıp orada değişiklikleri kaydettikten sonra ana dizine geri taşıyın.

### Kısayol Sembolleri

config.ini'de kısayolları düzenlerken şu sembolleri kullanın:

| Tuş | Sembol |
|-----|--------|
| Ctrl | `^` |
| Alt | `!` |
| Shift | `+` |
| Win | `#` |

Örnek: `^!Up` = Ctrl+Alt+Up, `#+Down` = Win+Shift+Down

## F-Tuşu Gönderici

Bu araç, klavye makro yazılımları (Logi Options+, Razer Synapse vb.) kullanırken sanal F13-F24 tuşlarını parlaklık kısayolu olarak atamanıza yardımcı olur.

![F-Tuşu Gönderici](assets/f-key_tool.png)

Nasıl çalışır:
1. Klavye yazılımınızı bir tuşa F13-F24 gönderecek şekilde yapılandırın
2. Ayarlar → F-Tuşu Gönderici açın
3. Atamak istediğiniz kısayol için Ayarlarda Yakala'ya tıklayın
4. F-Tuşu Gönderici'yi kullanarak tuşu gönderin ve yakalayın
5. Sanal tuş artık parlaklık kısayolunuz olarak atandı

## Kendi EXE'nizi Oluşturma

Script'i özelleştirmek ve kendi derlenmiş sürümünüzü oluşturmak istiyorsanız:

1. Mevcut `brightness_control.exe` dosyasını silin
2. [AutoHotkey v2.0](https://www.autohotkey.com/) yükleyin
3. `brightness_control.ahk` dosyasında değişikliklerinizi yapın
4. .ahk dosyasına sağ tıklayın → Compile Script
5. Kaynak olarak .ahk dosyanızı seçin
6. İsteğe bağlı olarak özel ikon (.ico dosyası) ayarlayın
7. Convert tıklayın

## Yüksek Öncelikli Başlangıç

Kurulum üç başlangıç seçeneği sunar:
- **Başlangıca ekleme** - Manuel başlatma
- **Normal başlangıç** - Başlangıç klasörü kısayolu (standart)
- **Yüksek öncelikli başlangıç** - Task Scheduler (diğer uygulamalardan önce başlar)

### Manuel Başlangıç Yapılandırması

PowerShell scriptlerini kullanarak başlangıcı manuel olarak yapılandırabilirsiniz (Yönetici olarak çalıştırın):

| Script | Açıklama |
|--------|----------|
| `install_startup_task.ps1` | Yüksek öncelikli başlangıcı etkinleştir |
| `make_normal_startup.ps1` | Normal başlangıca geç |
| `uninstall_startup_task.ps1` | Başlangıcı tamamen devre dışı bırak |

Durumu kontrol etmek için PowerShell ile çalıştırın: `schtasks /Query /TN "BrightnessController"`

## Kaldırma

`uninstall.exe` veya `uninstall.ahk` çalıştırarak aşağıdakileri tamamen kaldırın:
- Zamanlanmış görev
- Başlangıç kısayolu
- Kurulum klasörü

## Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `brightness_control.exe` | Ana uygulama (derlenmiş) |
| `brightness_control.ahk` | Ana uygulama (kaynak) |
| `setup.exe` | Kurulum programı |
| `setup.ahk` | Kurulum script'i (kaynak) |
| `uninstall.ahk` | Kaldırma script'i |
| `config.ini` | Yapılandırma (otomatik oluşturulur) |

## Sorun Giderme

Monitör algılanmıyor mu?
- Monitör OSD menüsünde DDC/CI etkinleştirin
- Monitör kablosunu yeniden bağlayın

Kısayollar çalışmıyor mu?
- Çakışan uygulamaları kontrol edin
- Yönetici olarak çalıştırın

## Lisans

MIT Lisansı

## Katkıda Bulunanlar

[@atakansariyar](https://github.com/atakansariyar) tarafından geliştirildi
