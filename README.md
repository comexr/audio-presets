# Audio Presets for PulseEffects or EasyEffects on CLEVO devices.

## How to apply the preset:

    1. Install Pulse Effects or Easy Effects on your system, depending on which sound server your operating system is using.
    2. Download the correct preset for your model laptop for the correct program.
       So if you have a Clevo NLx0MU and installed Pulse Effects you should download NLxMU_pulse.json
       You can open a terminal and execute the following command if you're not sure what your model laptop is:
        sudo dmidecode | grep "Name:" | head -n 1
    3. Open the program (PulseEffects or EasyEffects) to create the necessary folders
    4. Copy/Paste the downloaded file to: ~/.config/[PulseEffects or easyeffects]/output/
    5. The preset should now be selectable in the program
    
## Additional configuration:

    1. To apply the preset by default, open the program, go to the settings in the top-right corner 
       and toggle "Start Service at Login" on

## Notes:

    - Please note that this preset will be applied to ALL output devices. If you connect an 
      external speaker to the laptop this might not sound optimal. This can be fixed by also 
      downloading the preset "Headphones_pulse/easy.json" to the output folder
      Next, open the preset drop-down menu in the program and click the 2 curved arrows of the 
      preset you want to apply to the current output device. Say you've plugged in headphones, 
      please click the 2 curved arrows behind "Headphones". Then unplug the headphones so the speakers are 
      being used and click on the curved arrows behind the model specific preset. Now when you plug in your 
      headphones again, the program will automatically switch to the headphone preset.
    - There's a script available to handle the configuration automatically, but please note that 
      this script is experimental. If you experience any issues while using this script, 
      please contact: l.bruins@laptopwithlinux.com
      
 ### Here's how you can use the script:
      1. Clone the git repository
        git clone https://github.com/comexr/audio-presets.git
      2. Navigate to scripts folder
        cd audio-presets/scripts
      3. Modify execute rights
        sudo chmod +x audio_preset.sh
      4. Execute script
        ./audio_preset.sh
