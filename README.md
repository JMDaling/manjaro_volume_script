# Firefox Volume Control Script

## Introduction

I was experiencing an issue on my Manjaro Linux system with my **Lenovo ThinkBook 16p Gen 5** laptop, which features unique audio hardware with tweeter/bass **Harman Kardon** speakers. The volume levels would reset to 100% every time a new song played in YouTube Music. Additionally, the master volume control was only adjusting the tweeter speaker and not the front speakers. This script aims to address the volume reset issue by providing a way to control the volume of all active audio streams collectively.

## Issue Description

- **Laptop Model:** Lenovo ThinkBook 16p Gen 5
- **Audio Hardware:** Realtek ALC287 codec with Harman Kardon tweeter/bass speakers
- **Operating System:** Manjaro Linux
- **Kernel Versions Tried:**
  - `6.6.54-2-MANJARO` (LTS)
  - `6.10.13-3-MANJARO`
- **Problem:**
  - On kernel `6.6.54-2-MANJARO` (LTS), only the tweeter speaker produced sound.
  - After switching to kernel `6.10.13-3-MANJARO`, all speakers worked, but volume issues persisted.
  - The **Lenovo ThinkBook 16p Gen 5** has a unique audio setup with Harman Kardon tweeter and bass speakers, which may not be fully supported by the default drivers.
  - Master volume control only adjusted the tweeter speaker, not the front (bass) speakers.
  - Application volumes (e.g., in Firefox) reset to 100% on song change in YouTube Music.
  - Adjusting the `flat-volumes` setting in PulseAudio configuration presumably fixed the volume reset issue.
  - The script enables adjusting the volume up and down for applications, bypassing the master volume setting. This was tested in Firefox and applied to YouTube and WhatsApp Web.

## Fix Attempts

1. **Kernel Switching:**
   - Switched from the LTS kernel (`6.6.54-2-MANJARO`) to a newer kernel (`6.10.13-3-MANJARO`).
   - **Result:** Front speakers started working, but volume issues persisted.

2. **Audio Server Configuration:**
   - Tried adjusting PulseAudio and ALSA settings.
   - Switched between PipeWire and PulseAudio.
   - **Result:** Switching between PipeWire and PulseAudio had no effect.

3. **Audio Pin Remapping:**
   - Used `hdajackretask` to remap audio pins on the LTS kernel.
   - **Result:** Did not resolve the issue.

4. **Driver Changes:**
   - Attempted to switch between `snd_hda_intel` and `sof-hda-dsp` drivers.
   - **Result:** No improvement.

5. **Flat Volumes Setting:**
   - Adjusted the `flat-volumes` setting in PulseAudio (`flat-volumes = no`).
   - **Result:** Presumably fixed the volume reset issue.

## The `app-volume.sh` Script

To mitigate the issue with the volume resetting and to have control over the application volumes, I created a script that adjusts the volume of all active audio streams. This script can be bound to keyboard shortcuts for convenience.

### **Script Features**

- Adjusts the volume of all active sink inputs (audio streams) collectively.
- Bypasses the master volume setting, directly controlling application volumes.
- Provides a notification displaying the new volume level.
- Plays a system sound to indicate volume change.
- Rounds the volume to the nearest 5% for consistency.
- Tested in Firefox, applied to YouTube and WhatsApp Web.

### **Usage**

- **Increase Volume:**

  ```bash
  ./app-volume.sh --up
  ```


- **Decrease Volume:**

  ```bash
  ./app-volume.sh --down
  ```

### **Setting Up Keyboard Shortcuts**

1. Place the Script:

- Copy the `app-volume.sh` script to a directory in your PATH or a preferred location, such as `~/scripts/`.

2. Make the Script Executable:
    ```bash
    chmod +x ~/scripts/app-volume.sh
    ```

3. Create Symbolic Links (Optional):

    You can create symbolic links to the script in /usr/local/bin:
    ```bash
    sudo ln -s ~/scripts/app-volume.sh /usr/local/bin/app-volume
    ```

4. Configure Keyboard Shortcuts:  
- Go to your desktop environment's keyboard settings.  
- Add new shortcuts for volume up and volume down:  
    - Volume Up Command: `app-volume --up`  
    - Volume Down Command: `app-volume --down`  
- Assign your desired key combinations.  

## ALSA Information

For detailed hardware and driver information, please refer to the desensitized alsa-info.txt file included in this repository.

## Contributing

If you have suggestions or improvements, feel free to open an issue or submit a pull request.