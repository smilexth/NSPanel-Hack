#!/bin/bash

# NSPanel Pro Hack Unattended Installer Script
# Based on the README.md documentation
# This script attempts to automate more steps without user interaction

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  NSPanel Pro Hack Unattended Installer ${NC}"
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

# Get NSPanel IP address
if [ -z "$1" ]; then
    read -p "Enter the NSPanel Pro IP address: " NSPANEL_IP
else
    NSPANEL_IP=$1
    echo -e "${YELLOW}Using provided IP: $NSPANEL_IP${NC}"
fi

# Function to download required files
download_files() {
    echo -e "\n${BLUE}Downloading required files...${NC}"
    
    # Download Ultra Small Launcher
    if [ ! -f "downloads/ultra-small-launcher.apk" ]; then
        echo -e "${YELLOW}Downloading Ultra Small Launcher...${NC}"
        curl -s -L -o downloads/ultra-small-launcher.apk https://blakadder.com/assets/files/ultra-small-launcher.apk
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to download Ultra Small Launcher${NC}"
            exit 1
        fi
        echo -e "${GREEN}Ultra Small Launcher downloaded successfully${NC}"
    else
        echo -e "${GREEN}Ultra Small Launcher already downloaded.${NC}"
    fi
    
    # Download Home Assistant
    if [ ! -f "downloads/home-assistant.apk" ]; then
        echo -e "${YELLOW}Downloading Home Assistant...${NC}"
        LATEST_HA_URL=$(curl -s https://api.github.com/repos/home-assistant/android/releases/latest | 
                       grep "browser_download_url.*app-minimal-release.apk" | 
                       cut -d : -f 2,3 | 
                       tr -d \")
        curl -s -L -o downloads/home-assistant.apk "$LATEST_HA_URL"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to download Home Assistant${NC}"
            exit 1
        fi
        echo -e "${GREEN}Home Assistant downloaded successfully${NC}"
    else
        echo -e "${GREEN}Home Assistant already downloaded.${NC}"
    fi
    
    # Download NSPanel Pro Tools
    if [ ! -f "downloads/nspanel-pro-tools.apk" ]; then
        echo -e "${YELLOW}Downloading NSPanel Pro Tools...${NC}"
        LATEST_TOOLS_URL=$(curl -s https://api.github.com/repos/seaky/nspanel_pro_tools_apk/releases/latest | 
                          grep "browser_download_url.*release.apk" | 
                          head -n 1 | 
                          cut -d : -f 2,3 | 
                          tr -d \")
        curl -s -L -o downloads/nspanel-pro-tools.apk "$LATEST_TOOLS_URL"
        if [ $? -ne 0 ]; then
            echo -e "${RED}Failed to download NSPanel Pro Tools${NC}"
            exit 1
        fi
        echo -e "${GREEN}NSPanel Pro Tools downloaded successfully${NC}"
    else
        echo -e "${GREEN}NSPanel Pro Tools already downloaded.${NC}"
    fi

    # Check for Google TTS
    if [ ! -f "downloads/google-tts.apk" ]; then
        echo -e "${YELLOW}Google Text-to-Speech APK not found in downloads folder.${NC}"
        echo -e "${YELLOW}Please download Google Text-to-Speech manually from:${NC}"
        echo -e "${YELLOW}https://www.apkmirror.com/apk/google-inc/google-text-to-speech-engine${NC}"
        echo -e "${YELLOW}Choose variant: (arm64-v8a) (Android 8.0+)${NC}"
        read -p "Press Enter once you've downloaded the APK and placed it in the 'downloads' folder as 'google-tts.apk': "
        
        if [ ! -f "downloads/google-tts.apk" ]; then
            echo -e "${RED}Google TTS APK still not found. Aborting.${NC}"
            exit 1
        fi
    fi
    
    echo -e "${GREEN}All required files are ready.${NC}"
}

# Function to connect to NSPanel Pro
connect_to_nspanel() {
    echo -e "\n${BLUE}Connecting to NSPanel Pro...${NC}"
    
    # Try to disconnect existing connections first
    adb disconnect >/dev/null 2>&1
    
    # Try to connect to the device
    echo -e "${YELLOW}Connecting to $NSPANEL_IP...${NC}"
    adb connect "$NSPANEL_IP" >/dev/null 2>&1
    
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
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Ultra Small Launcher${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Installing Google Text-to-Speech...${NC}"
    adb install -r downloads/google-tts.apk
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Google Text-to-Speech${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Installing Home Assistant...${NC}"
    adb install -r downloads/home-assistant.apk
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install Home Assistant${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Installing NSPanel Pro Tools...${NC}"
    adb install -r downloads/nspanel-pro-tools.apk
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to install NSPanel Pro Tools${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}All APKs installed successfully!${NC}"
}

# Function to set home launcher automation
set_launcher() {
    echo -e "\n${BLUE}Setting Ultra Small Launcher as default...${NC}"
    
    # Press home button to trigger launcher selection
    adb shell input keyevent 3
    echo -e "${YELLOW}Sent HOME keyevent to device${NC}"
    
    # Wait for launcher dialog to appear
    sleep 2
    
    # Attempt to click on "Launcher" option (approximated coordinates)
    adb shell input tap 400 400
    echo -e "${YELLOW}Sent tap to select Launcher${NC}"
    
    # Wait a moment
    sleep 1
    
    # Attempt to click on "Always" option (approximated coordinates)
    adb shell input tap 550 600
    echo -e "${YELLOW}Sent tap to select Always${NC}"
    
    echo -e "${YELLOW}Attempted to set default launcher automatically. Verify on device.${NC}"
}

# Function to automate NSPanel Pro Tools configuration
configure_tools() {
    echo -e "\n${BLUE}Launching and configuring NSPanel Pro Tools...${NC}"
    
    # Start NSPanel Pro Tools
    adb shell monkey -p com.seaky.nspanelpro.tools -c android.intent.category.LAUNCHER 1
    echo -e "${YELLOW}Launched NSPanel Pro Tools${NC}"
    
    # Wait for app to start
    sleep 3
    
    # The rest would require more complex UI automation which might be unreliable
    # Instead, provide instructions
    echo -e "${YELLOW}Please complete these configuration steps manually on the device:${NC}"
    echo -e "${YELLOW}1. Grant all permissions requested by NSPanel Pro Tools${NC}"
    echo -e "${YELLOW}2. Tap 'Active' to activate the tools${NC}"
    echo -e "${YELLOW}3. Configure recommended settings as per the documentation${NC}"
    echo -e "${YELLOW}4. Especially make sure to enable 'Resume on boot' in Settings${NC}"
}

# Main function
main() {
    download_files
    connect_to_nspanel
    install_apks
    set_launcher
    configure_tools
    
    echo -e "\n${GREEN}Installation completed!${NC}"
    echo -e "${GREEN}All applications have been installed on your NSPanel Pro.${NC}"
    echo -e "\n${YELLOW}Manual steps required:${NC}"
    echo -e "${YELLOW}1. Configure Google TTS: Go to Settings -> System -> Languages & input -> Text-to-speech output${NC}"
    echo -e "${YELLOW}   - Set 'Speech Recognition & Synthesis from Google' as preferred engine${NC}"
    echo -e "${YELLOW}2. Configure NSPanel Pro Tools settings as described in the README${NC}"
    echo -e "${YELLOW}3. For MQTT integration, configure MQTT settings in NSPanel Pro Tools${NC}"
    
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
