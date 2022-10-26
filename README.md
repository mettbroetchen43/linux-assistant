# linux-assistant
Distribution indenpendent tool for everything, a linux desktop user needs. Written in flutter

## Requirements
```bash
sudo apt install keybinder-3.0 
sudo apt install libkeybinder-3.0-0 libkeybinder-3.0-dev # For debian

sudo apt install wmctrl
```

## Build
```bash
# Install keybinder, see requirements
sudo apt install snapd git
sudo snap install flutter --classic
flutter doctor # If command not found: Reboot and try again
git clone https://github.com/Jean28518/linux-assistant.git
cd linux-assistant
flutter build linux
cp -r additional build/linux/x64/release/bundle/

# Run: 
cd build/linux/x64/release/bundle/
./linux-assistant
```
