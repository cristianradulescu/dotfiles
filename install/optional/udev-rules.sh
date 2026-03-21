#!/usr/bin/env bash

# udev rules installation

PACKAGE_NAME="udev rules"

udev_install() {
  echo "Installing $PACKAGE_NAME..."

  # Flipper Zero
  echo "Installing Flipper Zero udev rules..."
  sudo tee /etc/udev/rules.d/99-flipper.rules <<EOF
#Flipper Zero serial port
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess", GROUP="dialout"
#Flipper Zero DFU
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", ATTRS{manufacturer}=="STMicroelectronics", TAG+="uaccess", GROUP="dialout"
#Flipper ESP32s2 BlackMagic
SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="40??", ATTRS{manufacturer}=="Flipper Devices Inc.", TAG+="uaccess", GROUP="dialout"
#Flipper U2F
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5741", ATTRS{manufacturer}=="Flipper Devices Inc.", ENV{ID_SECURITY_TOKEN}="1"
EOF

  # Dygma
  echo "Installing Dygma udev rules..."
  sudo tee /etc/udev/rules.d/99-dygma.rules <<EOF
# Dygma Raise
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", MODE="0660", TAG+="uaccess"
# bootloader mode
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", MODE="0660", TAG+="uaccess"

# Dygma USB Keyboards Vendor ID
SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
# bootloader mode
SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"

# Dygma HID Keyboards Vendor ID
KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
# bootloader mode
KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
EOF

  sudo udevadm control --reload-rules && sudo udevadm trigger

  echo "✓ $PACKAGE_NAME installed successfully"
}

main() {
  case "${1:-install}" in
    install|update) udev_install ;;
  esac
}

main "$@"
