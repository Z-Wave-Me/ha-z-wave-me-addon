## 4.1.2
- Upgradet to Z-Way 4.1.2
- Migration to Home Assistant Base Images: Transitioned from using base images of Ubuntu and rpi-balena to the official Home Assistant images with s6-overlay. This change ensures better compatibility and integration with the Home Assistant ecosystem.
- Updated the Z-Way server initialization script to ensure proper startup and configuration.
- Enhanced logging for better debugging and monitoring.
- Introduced a mechanism to fetch the local IP address for the Z-Way server.
- Implemented a system to set the logging level for the Z-Way server based on user input.
- Optimized the configuration handling to fetch values directly from the config without the need for intermediate variables.
- Improved the zbw_connect service startup script to ensure it starts correctly and logs its status.
- The "additional device" field has been added in which you can specify an additional interface that will be available for Z-Way.


## 4.1.0

- Update to v4.1.0
- Fixed factory reset bug

## 4.0.3

- Synced version with Z-Way version
- Add a field for local IP. Default is homeassistant.local, but you can set the IP if mDNS is not supported by your router

## 1.1.13

- Updated the z-way version to 4.0.3 
- Add checkbox for remote access
- Add tech support access checkbox and password (login support, default password razberry)
- Fix not showing homeassistant.local in find.z-wave.me
- Opened port 8883 for MQTT


## 1.1.12

- New ZBW 2.3 adopted
- Use homeassistant.local in find.z-wave.me instead of the local IP

## 1.1.8

- Save configs over restart
- Z-Wave device port selection from the HA settings UI

## 1.1.0

- Fixed build for non-amd64 architecture
- Add log tailing to addon

## 1.0.0

- Initial release
