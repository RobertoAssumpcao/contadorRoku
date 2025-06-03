# Contador Roku Channel

This repository contains the source code for the **Contador** channel used on Roku devices.

## Prerequisites

1. **Roku developer account.** You must have a developer account associated with your Roku device.
2. **Enable Developer Mode on the device.** Press `Home` three times, `Up` twice, `Right`, `Left`, `Right`, `Left`, `Right` on the remote. Note the IP address, username and password that appear, then reboot the device to complete activation.

## Sideloading the channel

### Using the web interface

A prebuilt package is available at `out/roku-deploy.zip`. Navigate to `http://<device-ip>` in your browser, sign in with your developer credentials and upload the zip file to install the channel.

### Using BrightScript tools

If you prefer a command line or IDE workflow, the BrightScript tooling (e.g. the VS Code extension) can sideload directly. Configure the target device IP and credentials, then run the `roku-deploy` command to package and push the app.

## Directory structure

```
/manifest      Channel manifest defining metadata and assets
/source/       Application entry points such as `Main.brs`
/components/   SceneGraph components and their BrightScript files
/images/       Channel artwork
/sounds/       Optional audio resources
/out/          Build output (e.g. `roku-deploy.zip` for sideload)
```

The `manifest` file provides Roku with the channel title, version and asset paths. `source` holds the main BrightScript code, while `components` contains SceneGraph XML components and their scripts.

## Debugging

Launch configurations for the BrightScript debugger are included in `.vscode/launch.json`. Select **BrightScript Debug: Launch** in VS Code and enter your Roku device's IP and password when prompted to attach the debugger.
