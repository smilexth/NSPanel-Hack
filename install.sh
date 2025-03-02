#!/bin/bash

# NSPanel Pro Hack Installer Script
# Based on the README.md documentation

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running with root privileges
if [ "$(id -u)" -eq 0 ]; then
  echo -e "${RED}Error: This script should not be run as root.${NC}"
  exit 1
fi

# Banner
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}        NSPanel Pro Hack Installer    ${NC}"
echo -e "${BLUE}======================================${NC}"
echo -e "${YELLOW}Based on the NSPanel Pro Hack README${NC}\n"

# Create downloads directory if it doesn't exist
mkdir -p downloads

# Check if adb is installed
if ! command -v adb &> /dev/null; then
    echo -e "${RED}Error: ADB is not installed. Please install Android SDK Platform Tools first.${NC}"
    echo -e "${YELLOW}Download from: https://developer.android.com/tools/releases/platform-tools${NC}"
    exit 1
fi

# Function to download required files
download_files() {
    echo -e "\n${BLUE}Downloading required files...${NC}"
    
    if [ ! -f "downloads/ultra-small-launcher.apk" ]; then
        echo -e "${YELLOW}Downloading Ultra Small Launcher...${NC}"
        curl -L -o downloads/ultra-small-launcher.apk https://blakadder.com/assets/files/ultra-small-launcher.apk
    else
        echo -e "${GREEN}Ultra Small Launcher already downloaded.${NC}"
    fi
    
    if [ ! -f "downloads/google-tts.apk" ]; then
        echo -e "${YELLOW}Downloading Google Text-to-Speech...${NC}"
        echo -e "${YELLOW}Please download Google Text-to-Speech manually from:${NC}"
        echo -e "${YELLOW}https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine${NC}"
        echo -e "${YELLOW}Choose variant: (arm64-v8a) (Android 8.0+)${NC}"
        read -p "Press Enter once you've downloaded the APK and placed it in the 'downloads' folder as 'google-tts.apk'" 
    else
        echo -e "${GREEN}Google Text-to-Speech already downloaded.${NC}"
    fi
    
    if [ ! -f "downloads/home-assistant.apk" ]; then
        echo -e "${YELLOW}Downloading Home Assistant...${NC}"
        # Get latest release URL
        LATEST_HA_URL=$(curl -s https://api.github.com/repos/home-assistant/android/releases/latest | 
                       grep "browser_download_url.*app-minimal-release.apk" | 
                       cut -d : -f 2,3 | 
                       tr -d \")
        curl -L -o downloads/home-assistant.apk "$LATEST_HA_URL"
    else
        echo -e "${GREEN}Home Assistant already downloaded.${NC}"
    fi
    
    if [ ! -f "downloads/nspanel-pro-tools.apk" ]; then
        echo -e "${YELLOW}Downloading NSPanel Pro Tools...${NC}"
        # Get latest release URL
        LATEST_TOOLS_URL=$(curl -s https://api.github.com/repos/seaky/nspanel_pro_tools_apk/releases/latest | 
                          grep "browser_download_url.*release.apk" | 
                          head -n 1 | 
                          cut -d : -f 2,3 | 
                          tr -d \")
        curl -L -o downloads/nspanel-pro-tools.apk "$LATEST_TOOLS_URL"
    else
        echo -e "${GREEN}NSPanel Pro Tools already downloaded.${NC}"
    fi
}

# Function to connect to NSPanel Pro
connect_to_nspanel() {
    echo -e "\n${BLUE}Connecting to NSPanel Pro...${NC}"
    echo -e "${YELLOW}Make sure your NSPanel Pro has Developer Mode and ADB enabled.${NC}"
    echo -e "${YELLOW}You can check the IP in Settings -> About -> IP.${NC}"
    
    # Ask for the IP address
    read -p "Enter the NSPanel Pro IP address: " NSPANEL_IP
    
    # Try to connect to the device
    echo -e "\n${YELLOW}Connecting to $NSPANEL_IP...${NC}"
    adb connect "$NSPANEL_IP"
    
    # Check if the connection was successful
    if ! adb devices | grep -q "$NSPANEL_IP"; then
        echo -e "${RED}Failed to connect to NSPanel Pro. Please check the IP and make sure ADB is enabled.${NC}"
        exit 1
    else
        echo -e "${GREEN}Successfully connected to NSPanel Pro!${NC}"
    fi
}

# Function to install APKs
install_apks() {
    echo -e "\n${BLUE}Installing APKs...${NC}"
    
    echo -e "${YELLOW}Installing Ultra Small Launcher...${NC}"
    adb install -r downloads/ultra-small-launcher.apk
    
    echo -e "${YELLOW}Installing Google Text-to-Speech...${NC}"
    adb install -r downloads/google-tts.apk
    
    echo -e "${YELLOW}Installing Home Assistant...${NC}"
    adb install -r downloads/home-assistant.apk
    
    echo -e "${YELLOW}Installing NSPanel Pro Tools...${NC}"
    adb install -r downloads/nspanel-pro-tools.apk
    
    echo -e "${GREEN}All APKs installed successfully!${NC}"
}

# Function to configure launcher
configure_launcher() {
    echo -e "\n${BLUE}Configuring Ultra Small Launcher...${NC}"
    
    echo -e "${YELLOW}Pressing HOME button to trigger launcher selection...${NC}"
    adb shell input keyevent 3
    
    echo -e "${YELLOW}Please select 'Launcher' and 'Always' on the device.${NC}"
    read -p "Press Enter once you've selected the launcher..." 
    
    echo -e "${YELLOW}Opening Display Settings for Navigation Bar...${NC}"
    adb shell am start -a com.android.settings.DISPLAY_SETTINGS
    
    echo -e "${YELLOW}Please enable 'Show status bar' in the Display settings.${NC}"
    read -p "Press Enter once you've enabled the status bar..." 
}

# Function to configure Text-to-Speech
configure_tts() {
    echo -e "\n${BLUE}Configuring Text-to-Speech...${NC}"
    
    echo -e "${YELLOW}Opening Text-to-Speech settings...${NC}"
    adb shell am start -a com.android.settings.TTS_SETTINGS
    
    echo -e "${YELLOW}Please select 'Speech Recognition & Synthesis from Google' as the preferred engine.${NC}"
    echo -e "${YELLOW}Select your preferred language, then increase the volume to maximum.${NC}"
    read -p "Press Enter once you've configured Text-to-Speech..." 
}

# Function to configure NSPanel Pro Tools
configure_nspanel_tools() {
    echo -e "\n${BLUE}Configuring NSPanel Pro Tools...${NC}"
    
    echo -e "${YELLOW}Launching NSPanel Pro Tools...${NC}"
    adb shell monkey -p com.seaky.nspanelpro.tools -c android.intent.category.LAUNCHER 1
    
    echo -e "${YELLOW}Please configure NSPanel Pro Tools following these steps:${NC}"
    echo -e "${YELLOW}1. Grant all permissions requested by the app${NC}"
    echo -e "${YELLOW}2. Press 'Active' to activate the tools${NC}"
    echo -e "${YELLOW}3. Configure Display settings:${NC}"
    echo -e "${YELLOW}   - Wakeup on wave: ON${NC}"
    echo -e "${YELLOW}   - Wakeup on gesture: Tab${NC}"
    echo -e "${YELLOW}   - Display sleep: 30 sec${NC}"
    echo -e "${YELLOW}4. Configure Tools:${NC}"
    echo -e "${YELLOW}   - Launch App after reboot: Home Assistant${NC}"
    echo -e "${YELLOW}   - Wait for WIFI: ON${NC}"
    echo -e "${YELLOW}   - Watchdog: ON${NC}"
    echo -e "${YELLOW}   - NavigationBar: OFF${NC}"
    echo -e "${YELLOW}   - Navigation Bar on swipe up: ON${NC}"
    echo -e "${YELLOW}   - Notification Bar on swipe down: ON${NC}"
    echo -e "${YELLOW}5. In Settings:${NC}"
    echo -e "${YELLOW}   - Audio feedback: ON${NC}"
    echo -e "${YELLOW}   - Resume on boot: ON${NC}"
    read -p "Press Enter once you've configured NSPanel Pro Tools..." 
}

# Main installation flow
main() {
    download_files
    connect_to_nspanel
    install_apks
    configure_launcher
    configure_tts
    configure_nspanel_tools
    
    echo -e "\n${GREEN}Installation completed successfully!${NC}"
    echo -e "${YELLOW}For MQTT integration with Home Assistant, please configure:${NC}"
    echo -e "${YELLOW}- Open NSPanel Pro Tools -> Integration -> MQTT${NC}"
    echo -e "${YELLOW}- Enter your MQTT host, port, username, and password${NC}"
    echo -e "${YELLOW}- Enable 'Push trigger events' and 'Home Assistant Integration'${NC}"
    echo -e "\n${BLUE}Enjoy your NSPanel Pro Hack!${NC}"
    
    # Ask if user wants to reboot the device
    read -p "Do you want to reboot the NSPanel Pro now? (y/n): " reboot_choice
    if [[ $reboot_choice == "y" || $reboot_choice == "Y" ]]; then
        echo -e "${YELLOW}Rebooting NSPanel Pro...${NC}"
        adb shell reboot
        echo -e "${GREEN}Device is rebooting. Wait for it to restart.${NC}"
    fi
}

# Run the installation
main
