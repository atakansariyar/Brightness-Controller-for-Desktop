# <img src="assets/brightness_icon.png" width="32" height="32"> Masaüstü Parlaklık Denetleyicisi

Dış monitörünüzün parlaklığını klavye kısayollarıyla kontrol edin - Windows 11 tarzı OSD ile.

![Demo](assets/demo.gif)

## Özellikler

- Dış monitörler için DDC/CI parlaklık kontrolü
- Windows 11 tarzı animasyonlu OSD popup
- Çoklu monitör desteği (tümü / imleç konumu / belirli monitör)
- Ayarlar GUI'si ile özelleştirilebilir kısayollar
- Klavye makro entegrasyonu için F-Tuşu Gönderici
- Çoklu dil: English, Türkçe, Русский, 中文, 日本語
- Sistem tepsisi entegrasyonu

## Gereksinimler

- Windows 10/11
- DDC/CI destekli dış monitör
- AutoHotkey v2.0 (sadece .ahk sürümü için)

## Kurulum

### Setup ile
1. `setup.ahk` dosyasını yönetici olarak çalıştırın
2. Kurulum tipini seçin (AHK veya EXE)
3. Windows başlangıcına eklenip eklenmeyeceğini seçin

**Öneri:** Kolaylık için EXE sürümünü kullanın. Özelleştirme isterseniz, dahil edilen `brightness_control.exe` dosyasını silip `brightness_control.ahk` dosyasını kendiniz derleyerek kendi EXE'nizi oluşturabilirsiniz.

### Manuel
1. Dosyaları istediğiniz konuma kopyalayın
2. `brightness_control.exe` çalıştırın (veya `.ahk` için AutoHotkey ile)

## Kısayol Yapılandırması

Kısayolları yapılandırmak için sistem tepsisinden **Ayarlar**'ı açın:

![Ayarlar](assets/settings.png)

1. Herhangi bir kısayol alanının yanındaki **Yakala** butonuna tıklayın
2. İstediğiniz tuşa basın
3. Tuş hemen atanır
4. Uygulamak ve yeniden başlatmak için **Kaydet**'e tıklayın

## F-Tuşu Gönderici

Bu araç, klavye makro yazılımları (Logi Options+, Razer Synapse vb.) kullanırken sanal F13-F24 tuşlarını parlaklık kısayolu olarak atamanıza yardımcı olur.

![F-Tuşu Gönderici](assets/f-key_tool.png)

**Kullanım alanları:**
- Bu uygulamada F13-F24 tuşlarını parlaklık kısayolu olarak atama
- Klavye yazılımı tuşlarını F13-F24 gönderecek şekilde yapılandırma (tuşun gönderilip gönderilmediğini doğrulamak için bu aracı kullanın)

**Nasıl çalışır:**
1. Klavye yazılımınızı bir tuşa F13-F24 gönderecek şekilde yapılandırın
2. Ayarlar → F-Tuşu Gönderici açın
3. Atamak istediğiniz kısayol için Ayarlarda **Yakala**'ya tıklayın
4. F-Tuşu Gönderici'yi kullanarak tuşu gönderin ve yakalayın
5. Sanal tuş artık parlaklık kısayolunuz olarak atandı

## Kendi EXE'nizi Oluşturma

Script'i özelleştirmek ve kendi derlenmiş sürümünüzü oluşturmak istiyorsanız:

1. [AutoHotkey v2.0](https://www.autohotkey.com/) yükleyin
2. `brightness_control.ahk` dosyasında değişikliklerinizi yapın
3. .ahk dosyasına sağ tıklayın → **Compile Script**
   - Alternatif: Başlat menüsü → AutoHotkey → **Ahk2Exe**
4. Kaynak olarak .ahk dosyanızı seçin
5. İsteğe bağlı olarak özel ikon (.ico dosyası) ayarlayın
6. **Convert** tıklayın
7. Eski EXE'yi silin ve yeni derlediğiniz sürümü kullanın

## Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `brightness_control.exe` | Ana uygulama (derlenmiş) |
| `brightness_control.ahk` | Ana uygulama (kaynak) |
| `setup.ahk` | Kurulum script'i |
| `assets/` | İkonlar ve medya dosyaları |
| `config.ini` | Yapılandırma (otomatik oluşturulur) |

## Sorun Giderme

**Monitör algılanmıyor mu?**
- Monitör OSD menüsünde DDC/CI etkinleştirin
- Monitör kablosunu yeniden bağlayın

**Kısayollar çalışmıyor mu?**
- Çakışan uygulamaları kontrol edin
- Yönetici olarak çalıştırın

## Lisans

MIT Lisansı

## Katkıda Bulunanlar

[@atakansariyar](https://github.com/atakansariyar) tarafından geliştirildi
