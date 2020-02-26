NodeMCU playground
==================

Links:

 - https://nodemcu.readthedocs.io/en/master/getting-started/


Quick notes:

 - `java -jar ESPlorer.jar`
 - `=print(file.getcontents('init.lua'))`
 - GPIO 4 == LED (on my board)
    - HIGH means internal LED is off
    - LOW means internal LED is on
 - `dofile('main.lua');`
 - `=file.remove('main.lua');`
 - `=file.remove('main.lc');`
 - `while /bin/true; do read x; wget http://192.168.0.171/ -O -; done`
    - damn Chromium _always_ send two requests, to `/` and to `/favicon.ico`
 - `ab -n25 http://192.168.0.171/`
    - Requests per second:    39.88 [#/sec] (mean)
    - Time per request:       25.073 [ms] (mean)
    - Power consumption (measured on 5V USB port):
        - 80..100 mA while benchmarking
        - 30 mA on idle
 - `sudo apt install mosquito mosquito-clients`
 - `mosquitto_sub -h 127.0.0.1 -t "#" -v` (monitor all topics)
 - `mosquitto_pub -t "/test/topic" -m "Hello, world"` (just to test)
    - `mosquitto_pub -t /test/topic -m set_high`
    - `mosquitto_pub -t /test/topic -m set_low`

```
# press Enter to toggle LED
while /bin/true; do
read x; mosquitto_pub -t /test/topic -m set_low;
read x; mosquitto_pub -t /test/topic -m set_high; done
```

```
# make sound on each button click
stdbuf -oL -eL mosquitto_sub -t "#" | \
stdbuf -oL -eL grep "button pressed" | \
while read line; do \
play -q /usr/share/sounds/freedesktop/stereo/dialog-information.oga; done
```


Websockets
----------

```
# File /etc/mosquitto/conf.d/websockets.conf

# default one
port 1883

# extra
listener 9001
protocol websockets
```


OTA
---

 - https://github.com/nodemcu/nodemcu-firmware/tree/master/lua_examples/luaOTA


MQTT + WS + JS
--------------

Идея примерно такая: есть модуль, сервер-брокер и управляющее приложение.

 - сервер Mosquitto просто есть, доступен по MQTT и WebSockets
    - на первом этапе нет никакой авторизации
    - на втором этапе добавим pre-shared password + TLS (бггг, ну да)

 - модуль NodeMCU при старте подключается к WiFi
    - синхронизирует дату/время
    - init.lua проверяет, нет ли обновлений для application.lua
 - модуль NodeMCU выполняет команды, получаемые по MQTT
    - включаем-выключаем светодиоды
    - пищим buzzer'ом
    - крутим сервопривод
 - модуль NodeMCU сообщает по MQTT о данных измерений
    - нажатие кнопки (keydown/keyup или keypress минус дребезг контактов)
    - положение потенциометра (?) (аналоговый вход всего один)
    - передача по событию (изменению состояния)
    - передача по таймауту (раз в N секунд)

 - управляющее приложение, dashboard, - это просто single-page web app,
   которое имеет доступ к Mosquitto по WebSockets, получает данные
   от модуля NodeMCU и выдаёт управляющие команды на NodeMCU,
   предоставляя пользователю кнопочки для управления модулем,
   красивые индикаторы состояния, какие-то типа умные графики;
   короче, типичная поделка «Hollywood OS», но таки _реально работающая_
 - допустим, используем Twitter Bootstrap 4, просто и аккуратно
 - должно работать на моём стареньком iPad 2 :)
 - должно работать без интернета
    - use case: отдельная Raspberry Pi в качестве сервера
        - WiFi AP для NodeMCU и iPad'а
        - Mosquitto (MQTT+WebSockets)
        - Nginx со статикой (Bootstrap, jQuery и наш dashboard SPA)
        - всё это может (и должно) жить и не падать без внешнего инета
 - права доступа и всё такое:
    - на первом этапе dashboard без ограничения прав доступа
    - на втором этапе будет "как бы логин" (без пароля) и read-only mode
        - вводим имя, но пароль не вводим
    - возможность запустить несколько dashboard'ов параллельно
        - действия других dashboard'ов видны
        - команды содержат логин оператора (имя? session id?)
        - нет, чат между dashboard'ами я не планирую
    - так или иначе, настоящего секьюрити я пока не планирую, поскольку
      у нас нет никакого backend'а и вопрос доступа решается самим
      фактом доступа к MQTT (доступ по паролю к отдельным топикам мутный),
      кто получил возможность подключиться - тот как бы сразу root, и всё
    - вообще, какая нафиг security может быть в IoT? :)

По традиции, начнём с самых тупых задач: при помощи всей этой фигни
мы будем мигать светодиодиком. Ха-ха.

Да, кстати
----------

Есть офигенное приложение, уииииииииииии!

https://play.google.com/store/apps/details?id=net.routix.mqttdash

 - подписывается на нужный топик и показывает последний полученный статус
 - по нажатию на кнопку отправляет нужную команду на топик

