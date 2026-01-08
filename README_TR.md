# Masaüstü için Parlaklık Kontrol

Harici monitörünüzün parlaklığını DDC/CI ile kontrol edin - Windows 11 tarzı şık bir OSD ile.

![Demo](demo.gif)

## Bu Proje Neden Var?

Bu aracı, **Logitech MX Keys S** klavyemdeki parlaklık tuşlarının harici monitörlerle çalışmadığını keşfettikten sonra geliştirdim. Windows, yerel parlaklık kontrolünü yalnızca laptop ekranlarında destekliyor ve harici monitör kullanıcılarını pratik bir çözüm olmadan bırakıyor.

Bu uygulama, monitörünüzle doğrudan DDC/CI protokolü üzerinden iletişim kurarak bu boşluğu dolduruyor ve bunu yaparken Windows 11 tarzı şık bir ekran göstergesi (OSD) sunuyor.

### En İyi Deneyim İçin

**Makro desteği olan klavyeler** (Logitech, Razer, Corsair vb.) en akıcı deneyimi sağlayacaktır. Kurulum şöyle:

1. Klavyenizin yazılımını açın (örn. **Logi Options+**, Razer Synapse, iCUE)
2. Çalışmayan parlaklık tuşlarını veya yeniden atamak istediğiniz tuşu bulun
3. Makro/tuş atama ayarlarına gidin
4. "Tuş dinleme" modundayken [**F-Key Sender**](https://github.com/ThioJoe/F-Key-Sender) kullanarak F13-F24 tuşlarını gönderin
5. Parlaklığı azaltmak için F13, artırmak için F14 atayın

### Neden F13-F24?

**F13 ve üzeri tuşları** kullanmanızı öneriyorum çünkü bu tuşlar neredeyse hiçbir uygulamada kullanılmıyor. Bu sayede parlaklık ayarlarken yanlışlıkla başka bir kısayolu tetiklemezsiniz.

## Özellikler

- 🌞 **DDC/CI Desteği** - DDC/CI protokolünü destekleyen harici monitörlerle çalışır
- 🎨 **Windows 11 Tarzı OSD** - Yuvarlatılmış köşeler ve akıcı animasyonlarla modern popup
- 🌗 **Otomatik Tema Algılama** - Light ve dark tema arasında otomatik geçiş
- ⌨️ **Özelleştirilebilir Kısayollar** - İstediğiniz tuş kombinasyonunu ayarlayın
- 🚀 **Akıcı Animasyonlar** - DWM senkronizasyonlu donanım hızlandırmalı animasyonlar
- 🔧 **Yüksek Özelleştirme** - Popup boyutu, renkler, animasyon hızı ve daha fazlası

## Gereksinimler

- **Windows 10/11**
- **AutoHotkey v2.0** - [Buradan indirin](https://www.autohotkey.com/) *(hazır EXE indirirseniz gerekmez)*
- **DDC/CI uyumlu monitör** - Çoğu harici monitör bunu destekler (monitörünüzün OSD ayarlarını kontrol edin)

### F13-F24 Tuşları İçin

Klavyenizde F13-F24 tuşları yoksa, **F-Key Sender** ile diğer tuşları yeniden eşleyebilirsiniz:
- [F-Key Sender by ThioJoe](https://github.com/ThioJoe/F-Key-Sender)

## Kurulum

### Yöntem 1: Hazır EXE İndir (En Kolay)

1. Bu repodan `brightness_control.exe` dosyasını indirin
2. Çift tıklayarak çalıştırın - **kurulum gerektirmez!**

### Yöntem 2: Script Olarak Çalıştır

1. [AutoHotkey v2.0](https://www.autohotkey.com/) yükleyin
2. `brightness_control.ahk` dosyasını indirin
3. Çift tıklayarak çalıştırın

### Yöntem 3: Kendiniz EXE'ye Derleyin

**Hızlı yol:** `brightness_control.ahk` → sağ tık → **Compile Script** *(bazı sistemlerde çalışmayabilir)*

**Ahk2Exe GUI ile (önerilen):**

1. Başlat Menüsü'nde **Ahk2Exe** arayın
2. Şu ayarları yapın:
   - **Source:** `brightness_control.ahk` dosyasını seçin
   - **Destination:** `.exe` dosyasının kaydedileceği yeri seçin
   - **Base File:** `AutoHotkey64.exe` seçin (64-bit için) veya varsayılanı bırakın
3. **Convert** tıklayın

## Windows Başlangıcında Otomatik Çalıştırma

### Startup Klasörü (Önerilen)

1. `Win + R` tuşlarına basın
2. `shell:startup` yazın ve Enter'a basın
3. Bu klasöre `brightness_control.ahk` (veya `.exe`) için kısayol oluşturun

### Görev Zamanlayıcı ile

1. Görev Zamanlayıcı'yı açın
2. Temel Görev Oluştur → Tetikleyiciyi "Başlangıçta" olarak ayarlayın
3. Eylemi script/exe'yi başlatmak için ayarlayın

## Yapılandırma

Script dosyasını düzenleyerek özelleştirin:

```autohotkey
; Kısayol tuşları (devre dışı bırakmak için "" bırakın)
hotkeyDecrease := "F13"       ; Parlaklığı azalt
hotkeyIncrease := "F14"       ; Parlaklığı artır

; Parlaklık Kontrolü
brightnessStep := 10          ; Tuş başına değişim (1-100)

; Popup Davranışı
popupTimeout := 2000          ; Popup kapanmadan önce bekleme süresi (ms)

; Animasyon
animationEnabled := true
animationDuration := 200      ; Açılış animasyonu (ms)
```

### Kısayol Örnekleri

| Tuşlar | Değer |
|--------|-------|
| F13 | `"F13"` |
| Ctrl + Eksi | `"^-"` |
| Ctrl + Artı | `"^="` |
| Win + Yukarı | `"#Up"` |
| Alt + F1 | `"!F1"` |

## Sorun Giderme

### Monitör Algılanmıyor

1. Monitörünüzün OSD ayarlarından **DDC/CI'yi etkinleştirin**
2. **Doğrudan kablo bağlantısı** kullandığınızdan emin olun (KVM veya dock üzerinden değil)
3. Farklı bir kablo deneyin (DisplayPort ve HDMI ikisi de DDC/CI destekler)

### Parlaklık Değişmiyor

- Bazı monitör markaları sınırlı DDC/CI desteğine sahiptir
- Grafik sürücülerinizi güncellemeyi deneyin
- Diğer DDC/CI araçlarının çalışıp çalışmadığını kontrol edin (örn: ControlMyMonitor, Monitorian)

## Teknik Detaylar

- Windows DDC/CI API'si `Dxva2.dll` üzerinden kullanılır
- 4x supersampling ile anti-aliased GDI+ rendering
- Yumuşak yuvarlatılmış köşeler için per-pixel alpha'lı layered window
- Hassas animasyon zamanlaması için QueryPerformanceCounter
- VSync senkronizasyonu için DwmFlush

## Lisans

MIT Lisansı - [LICENSE](LICENSE) dosyasına bakın

## Teşekkürler

- [AutoHotkey v2](https://www.autohotkey.com/) ile geliştirildi
- Windows 11 ses/parlaklık OSD'sinden ilham alındı
