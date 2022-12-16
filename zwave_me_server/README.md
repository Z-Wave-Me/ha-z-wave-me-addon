# Z-Wave.Me add-on for Home Assistant

This add-on starts Z-Wave.Me Z-Way server in a supervised Home Assistant (HAOS). Z-Way server can then be used in Home Assistant via the [Z-Wave.Me intergration](https://www.home-assistant.io/integrations/zwave_me).

Z-Way interface can be accessed on port 8083.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FZ-Wave-Me%2Fha-z-wave-me-addon)

Z-Wave.Me Z-Way is a complete Smart Home Controller Software supporting Z-Wave and EnOcean radio protocols, as well as WiFi, MQTT and HTTP-based devices.

Z-Way key features:
- Complete Smart Home Controller software for various platforms
- Supports Z-Wave Security S2, Smart Start and Long Range
- Tested against more than 700 physical devices for interoperability
- Easy to integrate with other systems in your home
- Built-in network diagnostics tools
- Provides an easy to use and very flexible HTTP API

Z-Way is a good match for Home Assistant, giving you the performance of the Z-Way engine with full control over Z-Wave devices and the flexibility of Home Assistant's UI.

![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports i386 Architecture][i386-shield]
<!-- ![Supports aarch64 Architecture][aarch64-shield] -->
<!-- ![Supports armv7 Architecture][armv7-shield] -->

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

## Using Razberry 2, Razberry 5, Razberry 7 and 7 Pro
This board is installed on the Raspberry Pi GPIO and uses the built-in UART for communication, this line also uses the built-in Bluetooth, which must be excluded at the operating system level.
First, you need to connect via SSH to the HAOS host system. Instructions that indicate how to do this:
https://developers.home-assistant.io/docs/operating-system/debugging/
There is also our complete instructions for installing HAOS, which describes in detail how to disable bluetooth:
https://help.z-wave.me/en/knowledge_base/article/146/category/88/

After you connect via SSH, run the command:

echo "dtoverlay=pi3-disable-bt" >> /mnt/boot/config.txt

This command will disable bluetooth at the system level, then restart your Raspberry Pi, after that Z-Way will be able to work with this board
