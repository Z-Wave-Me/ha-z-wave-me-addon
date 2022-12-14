# Z-Wave.Me add-on for Home Assistant
This add-on starts Z-Wave.Me Z-Way server in a supervised Home Assistant (HAOS) and Home Assistant Yellow.

# Install Z-Way add-on
Add this add-on to your Home Assistant

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fz-wave-me%2Fha-z-wave-me-addon)

![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports aarch64 Architecture][aarch64-shield]
<!-- ![Supports i386 Architecture][i386-shield] -->
<!-- ![Supports armv7 Architecture][armv7-shield] -->

Once installed, Z-Way interface can be accessed on port 8083.

# Integrate with Home Assistant
After installing this add-on, add [Z-Wave.Me intergration](https://www.home-assistant.io/integrations/zwave_me) to your Home Assistant to integrate devices present in Z-Way in Home Assistant UI.

[![Open your Home Assistant instance and show the integration dialog with a specific integration URL pre-filled.](https://my.home-assistant.io/badges/config_flow_start.svg)](https://my.home-assistant.io/redirect/config_flow_start?domain=zwave_me)

# What is Z-Way?
Z-Wave.Me Z-Way is a complete Smart Home Controller Software supporting Z-Wave and EnOcean radio protocols, as well as WiFi, MQTT and HTTP-based devices.

Z-Way key features:
- Complete Smart Home Controller software for various platforms
- Supports Z-Wave Security S2, Smart Start and Long Range
- Tested against more than 700 physical devices for interoperability
- Easy to integrate with other systems in your home
- Built-in network diagnostics tools
- Provides an easy to use and very flexible HTTP API

Z-Way is a good match for Home Assistant, giving you the performance of the Z-Way engine with full control over Z-Wave devices and the flexibility of Home Assistant's UI.

Home inforation about Z-Way can be found on the [Z-Wave.Me web site](https://z-wave.me/z-way/).

[Z-Way manual](https://z-wave.me/manual/z-way/)

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg


## Use together with Raspberry 2, Razberry 5, Raspberry 7, Raspberry 7 Pro
To use these boards, bluetooth must be disabled on the Host system. To do this, you will need to enable SSH access, official instructions: 
https://developers.home-assistant.io/docs/operating-system/debugging/
Our full version of the instructions:
https://help.z-wave.me/en/knowledge_base/art/146/cat/88/

After you connect via SSH to the controller, run the command and reboot your Raspberry Pi by disconnecting the power supply:
```
echo "dtoverlay=pi3-disable-bt" >> /mnt/boot/config.txt
```
##Use with UZB
When using UZB, you do not need to disable the built-in bluetooth, and in the add-on settings you need to specify the port to the USB device, usually it is `/dev/ttyACM0`s