# คู่มือ NSPanel Pro Hack

*Update : 1 Mar 2025*

## สารบัญ

- [คู่มือ NSPanel Pro Hack](#คู่มือ-nspanel-pro-hack)
  - [สารบัญ](#สารบัญ)
  - [เตรียมความพร้อม](#เตรียมความพร้อม)
  - [วิธีเปิดใช้งานครั้งแรก และ เปิด developer mode และ adb บน ns panel pro และ reset](#วิธีเปิดใช้งานครั้งแรก-และ-เปิด-developer-mode-และ-adb-บน-ns-panel-pro-และ-reset)
  - [วิธีเปิดใช้งาน และ การดู local ip ของ ns panel pro โดยไม่ต้อง ip scan หรือ ดูในเราเตอร์](#วิธีเปิดใช้งาน-และ-การดู-local-ip-ของ-ns-panel-pro-โดยไม่ต้อง-ip-scan-หรือ-ดูในเราเตอร์)
  - [วิธีการ adb shell เข้าไปใน ns panel pro และคำสั้ง adb เบื้องต้น](#วิธีการ-adb-shell-เข้าไปใน-ns-panel-pro-และคำสั้ง-adb-เบื้องต้น)
  - [วิธีการติดตั้งและตั้งค่า Launcher](#วิธีการติดตั้งและตั้งค่า-launcher)
  - [วิธีการติดตั้งและตั้งค่า Text to Speech](#วิธีการติดตั้งและตั้งค่า-text-to-speech)
  - [วิธีการติดตั้ง Home Assistant](#วิธีการติดตั้ง-home-assistant)
  - [วิธีการติดตั้งและตั้งค่า NSPanel Pro Tools](#วิธีการติดตั้งและตั้งค่า-nspanel-pro-tools)
  - [วิธีการใช้งาน NSPanel Pro Tools และ ฟีเจอร์ทั้งหมด และการนำเข้า Home Assistant](#วิธีการใช้งาน-nspanel-pro-tools-และ-ฟีเจอร์ทั้งหมด-และการนำเข้า-home-assistant)
    - [1. Display](#1-display)
    - [2. Sensor](#2-sensor)
    - [3. Tools](#3-tools)
    - [4. Integration](#4-integration)
    - [5. Settings](#5-settings)
  - [แหล่งที่มา อ้างอิง](#แหล่งที่มา-อ้างอิง)

## เตรียมความพร้อม

1. เตรียมมือถือ android หรือ iphone ก็ได้ ที่ได้ติดตั้ง application "eWeLink" และ sign in ไว้เป็นที่เรียบร้อยแล้ว

   สามารถ ดาวน์โหลด "eWeLink" ได้ที่  
   Play Store : [https://play.google.com/store/apps/details?id=com.coolkit](https://play.google.com/store/apps/details?id=com.coolkit)  
   App Store : [https://apps.apple.com/th/app/ewelink/id1035163158](https://apps.apple.com/th/app/ewelink/id1035163158)

---

2. เตรียมคอมพิวเตอร์ จะเป็น Windows Linux Mac ก็ได้

   *ไม่จำเป็นต้องมี desktop environments เพราะเป็น command-line ล้วนๆ*

   ติดตั้ง ADB drivers (เฉพาะจะใช้ adb ผ่าน usb ถ้าใช้ adb over tcp ให้ข้ามการติดตั้งนี้ไป)

   - Windows ดาวน์โหลดได้ที่ [https://developer.android.com/studio/run/win-usb](https://developer.android.com/studio/run/win-usb)
   - Mac ไม่ต้องลง driver `brew install android-platform-tools`
   - Linux (Ubuntu) `apt-get install android-sdk-platform-tools-common`

   ติดตั้ง Android SDK Platform Tools

   ดาวน์โหลดได้ที่ [https://developer.android.com/tools/releases/platform-tools](https://developer.android.com/tools/releases/platform-tools)

---

3. เตรียม wifi ไว้ให้ ns panel pro เชื่อมต่อ และ ต้องอยู่ใน local network เดียวกันกับคอมพิวเตอร์ที่จะไว้ setup

---

4. ดาวน์โหลด Android Packages ที่จำเป็นต้องใช้ในขั้นตอนถัดไป

   - **"Ultra Small Launcher" APK**  
     ดาวน์โหลดได้ที่ [https://blakadder.com/assets/files/ultra-small-launcher.apk](https://blakadder.com/assets/files/ultra-small-launcher.apk)

   - **"Speech Recognition & Synthesis By Google" APK**  
     มีให้เลือกดาวน์โหลดจาก 2 Source (แนะนำ apkmirror)  
     [https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine](https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine)  
     สำหรับ apkmirror ให้เลือก Variant เป็น (arm64-v8a) (Android 8.0+) และ ดาวน์โหลดตัวล่าสุด

     [https://apkpure.com/speech-recognition-synthesis/com.google.android.tts](https://apkpure.com/speech-recognition-synthesis/com.google.android.tts)  
     สำหรับ apkpure ให้กด Download APK ได้เลย (ตรง More Information จะระบุว่า Requires Android: Android 8.0+ และ Architecture: arm64-v8a)

   - **"Home Assistant Android" APK**  
     ดาวน์โหลดได้ที่ [https://github.com/home-assistant/android/releases](https://github.com/home-assistant/android/releases)  
     ให้เลือกดาวน์โหลดเป็น "app-minimal-release.apk"  
     *ทำไมถึงต้องเลือก minimal flavor เพราะไม่ต้องมี Google Play Services ก็สามารถใช้ hass ได้*

   - **"NSPanel Pro Tools" APK**  
     ดาวน์โหลดได้ที่ [https://github.com/seaky/nspanel_pro_tools_apk/releases](https://github.com/seaky/nspanel_pro_tools_apk/releases)  
     ให้เลือกดาวน์โหลดเป็น "nspanel-pro-tools-X.X.X-release.apk"

## วิธีเปิดใช้งานครั้งแรก และ เปิด developer mode และ adb บน ns panel pro และ reset

1. จ่ายไฟให้ ns panel pro แล้วเลือก ภาษา ภูมิภาค และเชื่อมต่อ wifi ให้เรียบร้อย

2. เข้าแอพ eWeLink แล้วทำการเพิ่ม ns panel pro โดยสแกน qr code บนหน้าจอ

3. อัพเดทซอฟท์แวร์ ให้ล่าสุด *optional แต่แนะนำให้ทำ*

   ปัดหน้าจอลง กด "การตั้งค่า" -> "เกี่ยวกับ"-> "อัพเดทซอฟท์แวร์"

   *เพราะหลังจากเปิด dev mode ตัว ns panel pro จะถูกตัดประกัน และ อัพเดท*

4. วิธีการเปิด Developer Mode

   กดที่ อุปกรณ์ -> กดสามจุดมุมบนขวา -> กด "หมายเลขอุปกรณ์" หลายๆครั้งจนขึ้น popup

   กด "โหมดนักพัฒนา" -> กด "ADB" -> กด "ยอมรับและเปิดการทำงาน"

5. เปิด Zigbee Turbo และ เปลี่ยนโหมด Zigbee *optional*

   กดที่ อุปกรณ์ -> กดสามจุดมุมบนขวา -> ฟีเจอร์รุ่นทดลอง  
   กดเปิด Zigbee Turbo และกดที่โหมด โหมด Zigbee  
   แล้วก็กด เปลี่ยนเข้าสู่เราเตอร์โหมด

   *การเปลี่ยนโหมด Zigbee จะทำให้ ns panel pro คืนค่าจากโรงงาน และเลิกผูกกับ eWeLink โดยอัตโนมัติ*

   ถ้าทำขั้นตอนนี้จะข้ามขั้นตอนที่ 6 ไปได้เลย

6. เลิกผูกอุปกรณ์จาก eWeLink (ถ้าใช้บัญชี eWeLink ของช่างหรือผู้ติดตั้งในการ setup)

   จะทำได้ 2 วิธี (แนะนำให้ทำผ่าน ns panel pro จะง่ายกว่า)

   - ทำผ่าน ns panel pro ดังนี้ ปัดหน้าจอลง กด "การตั้งค่า" -> "เกี่ยวกับ"-> "ตั้งค่าใหม่"
   - ทำผ่านแอพ eWeLink โดย กดที่ อุปกรณ์ -> กดสามจุดมุมบนขวา -> "ลบอุปกรณ์"

   หลังจากเลิกผูกอุปกรณ์ จาก บัญชี eWeLink ตัว ns panel pro จะคืนค่าโรงงาน เหมือนตอนแกะกล่อง จะเป็นอันเสร็จสิ้น

## วิธีเปิดใช้งาน และ การดู local ip ของ ns panel pro โดยไม่ต้อง ip scan หรือ ดูในเราเตอร์

หลังจากเราได้เลิกผูก หรือ reset อุปกรณ์แล้ว  
ก็ให้เลือก ภาษา ภูมิภาค และเชื่อมต่อ wifi ให้เรียบร้อย แต่ !!! ไม่ต้องผูก eWeLink !!!

วิธีดู IP คือ ปัดหน้าจอลง กด "การตั้งค่า" -> เกี่ยวกับ -> IP

แค่นี้ ns panel pro ก็จะพร้อมใช้งานในขั้นตอนถัดไป

## วิธีการ adb shell เข้าไปใน ns panel pro และคำสั้ง adb เบื้องต้น

เข้า terminal (ฝั่ง linux, mac) หรือ cmd (สำหรับฝั่ง windows) เข้าไปในโฟลเดอร์ Platform Tools

วิธีเชื่อมต่อ adb over tcp โดยใช้คำสั่งตามนี้ (ใช้ ip ของ ns panel pro)

```
adb connect {ip}    ex. adb connect 192.168.1.XXX
```

ถ้าเชื่อมต่อสําเร็จจะตอบกลับมาว่า
```
connected to 192.168.1.XXX
```

คำสั่งในการส่ง keyevent หรือ tab เข้าไปใน ns panel pro

```
adb shell input keyevent {key}       ex. adb shell input keyevent 3
adb shell input tap {x pixel} {y pixel}    ex. adb shell input tap 420 400
```

คำสั่งในการดู packages ใน ns panel pro และ ติดตั้งแอพ ถอนการติดตั้งแอพ

```
adb shell cmd package list packages
adb install {apk path}           ex. adb install nspanel-pro-tools-2.2.2-release.apk
adb uninstall {package name}     ex. adb uninstall com.seaky.nspanelpro.tools
```

## วิธีการติดตั้งและตั้งค่า Launcher

1. วิธีติดตั้ง Ultra Small Launcher

   ใช้คำสั่ง `adb install ultra-small-launcher.apk`

   แล้วรอติดตั้งสักครู่ จน terminal ตอบกลับมาว่า Success
 
2. วิธีเปลี่ยน Default Launcher

   ใช้คำสั่ง `adb shell input keyevent 3`

   จะมี popup "Select a Home app" ขึ้นมา  
   ให้กดเลือก "Launcher " แล้วกด "Always"

3. วิธีการเปิด Navigation Bar

   กดไปที่ Settings -> Display -> show status bar แล้วกดเปิด  
   หรือจะใช้คำสั่ง `adb shell am start -a com.android.settings.DISPLAY_SETTINGS` เพื่อเข้าหน้า Display 

## วิธีการติดตั้งและตั้งค่า Text to Speech
เข้า terminal (ฝั่ง linux, mac) หรือ cmd (สำหรับฝั่ง windows) เข้าไปในโฟลเดอร์ Platform Tools


1. วิธีติดตั้ง Speech Recognition & Synthesis

   ใช้คำสั่ง `adb install google-speech-arm64-v8a.apk`

   แล้วรอติดตั้งสักครู่ จน terminal ตอบกลับมาว่า Success

2. วิธีเปลี่ยน TTS Engines

   กดไปที่ Settings -> "System" -> "Languages & input" -> "Advanced" -> "Text-to-speech output"

   หรือ จะใช้คำสั่ง `adb shell am start -a com.android.settings.TTS_SETTINGS` เพื่อไปหน้า Text-to-speech output

   กด "Preferred engine"-> "Speech Recognition & Synthesis from Google"-> "OK"

   ตอนนี้ Text-to-speech ก็จะพร้อมใช้งาน (เพิ่มเสียงตรงเมนูบาร์ขวาล่าง เพิ่มเสียงให้สุดด้วย)

   > **Note**: เลือกภาษา tts ให้เรียบร้อย ได้แค่ 1 ภาษา จะเอา eng หรือ ไทย เป็นหลักไปเลย  
   > **Note**: ทำไมถึงไม่ใช้ Pico TTS เพราะ เสียงมันเหมือนหุ่นยนต์ มากกกกก

## วิธีการติดตั้ง Home Assistant

1. วิธีติดตั้ง Home Assistant

   ใช้คำสั่ง `adb install app-minimal-release.apk`

   แล้วรอติดตั้งสักครู่ จน terminal ตอบกลับมาว่า Success

## วิธีการติดตั้งและตั้งค่า NSPanel Pro Tools

1. วิธีติดตั้ง NSPanel Pro Tools

   ใช้คำสั่ง `adb install nspanel-pro-tools-X.X.X-release.apk` (X.X.X ให้เปลี่ยนเป็นเลข ver. ที่โหลดมา)

   แล้วรอติดตั้งสักครู่ จน terminal ตอบกลับมาว่า Success

2. วิธีการตั้งค่า NSPanel Pro Tools เบื้องต้น

   ให้กดเปิดแอพ NSPanelTools แล้วให้ permission ให้เรียบร้อย (ให้กดย้อนกลับ เพื่อกลับมาที่ tools)

   แล้วกด active

## วิธีการใช้งาน NSPanel Pro Tools และ ฟีเจอร์ทั้งหมด และการนำเข้า Home Assistant

ใน NSPanelTools หรือเราจะเรียกสั้นว่า Tools จะมี 5 เมนูหลักๆคือ 

* **Display** - ไว้เซ็ต Wakeup Brightness Screen
* **Sensor** - ไว้เซ็ต Proximity Sensor, Light Sensor
* **Tools** - ไว้เซ็ต AutoStart และ System UI
* **Integration** - ไว้เซ็ต mqtt (สำหรับเอาเข้า Home Assistant integration) และ zigbee ในอนาคต
* **Settings** - ไว้เซ็ตทั่วไปพวก audio feedback, resume on boot, hostname, reboot

### 1. Display

ในหมวดหมู่ Wakeup 

- Wakeup on wave : ON - ให้เปิดจอตอนเอามือปัดผ่านหน้าจอ
- Wakeup on gesture : Tab - ให้เปิดจอตอนเราทัชจอตามรูปแบบที่กำหนดมี tab dubble triple ปัด ขั้น ลง ซ้าย ขวา
- Wake from Screensaver : OFF

ในหมวดหมู่ Brightness 

- Brightness : 100%
- Brightness on light-below - ถ้า trigger แสงน้อย ให้ปรับแสงหน้าจอเป็นเท่าไหร  
- Brightness on light-above - ถ้า trigger แสงมาก ให้ปรับแสงหน้าจอเป็นเท่าไหร

ในหมวดหมู่ Screen

- Display sleep : 30 sec - ตั้งเวลาปิดหน้าจอตั้งแต่ 30 วินาที ถึง 30 นาที
- Display sleep mode : Screen off - เลือกเวลาพักหน้าจอว่าจะปิดจอ หรือหรี่แสงหน้าจอ
- Screen-on time - ตั้งเวลาเปิดปิดหน้าจอ ตามวันเวลา

### 2. Sensor 

หลักๆมีไว้ดูค่า Proximity Sensor แล้วปรับความไวในการ trigger แบบให้มือเราปัดไกล้หน้าจอแค่ไหน
และดูค่า Light Sensor และปรับแสงมาก แสงน้อย เท่าไหรถึงจะ trigger 

### 3. Tools 

ใน AutoStart เราจะเซ็ต
- Launch App after reboot : Home Assistant - หรือ eWeLinkControlPannel ถ้าอยากกลับไปใช้เดิมๆ หรือ webview
- Wait for WIFI : ON - ให้รอเปิดแอพ hass หลังจาก nspanel ได้ต่อ wifi & internet แล้ว
- Watchdog : ON - ถ้าแอพ hass ค้าง tools จะรีแอพให้

ใน System UI เพื่อความสวยงามให้ตั้งตามนี้
- NavigationBar : OFF - เพื่อไม่ให้มีแถม menu โชว์ตลอดเวลาให้รกตา
- Navigation Bar on swipe up : ON - เปิดปัดหน้าจอขึ้นให้โชว์ menu bar ไว้กด home back
- Notification Bar on swipe down : ON - เปิดปัดหน้าจอลงให้เปิด Navigation Bar ไว้ตั้งค่า wifi bt

### 4. Integration 

ฟีเจอร์ zigbee ตอนนี้ยังไม่เปิดใช้งาน รอ tools update

ในเมนู mqtt หลักๆมีไว้ใส่ host port user pass ของ mqtt
และให้เลือก push trigger event และ เปิดฟีเจอร์ Home Assistant integration

### 5. Settings

ใน General
- Audio feedback : ON - เวลาเอามือทัชจอ จะได้มีฟีดแบค
- Resume on boot : ON - เวลา boot จะได้กลับมาเปิด tools !!ต้องเปิด สำคัญมาก!!

ใน Reboot
- กด Reboot device ผ่านตรงนี้ได้
- หรือตั้ง Scheduled reboot ได้ ให้ Reboot ถี่แค่ไหน เวลาได้

คู่มือ/รูปภาพ Tools เพิ่มเติมดูได้ที่ [https://github.com/seaky/nspanel_pro_tools_apk](https://github.com/seaky/nspanel_pro_tools_apk)

[https://companion.home-assistant.io/docs/notifications/notifications-basic/#text-to-speech-notifications](https://companion.home-assistant.io/docs/notifications/notifications-basic/#text-to-speech-notifications)

## แหล่งที่มา อ้างอิง

- [https://blakadder.com/nspanel-pro](https://blakadder.com/nspanel-pro)
- [https://blakadder.com/nspanel-pro-sideload](https://blakadder.com/nspanel-pro-sideload)
- [https://blakadder.com/nspanel-pro-secrets](https://blakadder.com/nspanel-pro-secrets)
- [https://gist.github.com/arjunv/2bbcca9a1a1c127749f8dcb6d36fb0bc](https://gist.github.com/arjunv/2bbcca9a1a1c127749f8dcb6d36fb0bc)
