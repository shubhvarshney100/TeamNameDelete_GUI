# **TEAM NAME DELETE: Secure Data Wiping for Trustworthy IT Asset Recycling**
**A cross-platform data sanitization tool developed for the HackIndia Spark 6 @ NIT Delhi.**

## 📖 About the Project
India faces a significant e-waste crisis, with millions of electronic devices being improperly discarded or hoarded due to fears of data breaches. SecureWipe is a user-friendly, cross-platform application designed to address this challenge by providing a secure, verifiable, and accessible way for individuals and organizations to wipe their storage devices.

Built with C++ and the Qt Framework, this tool ensures that sensitive data is permanently destroyed, building user confidence in IT asset recycling and promoting a circular economy.

## ✨ Key Features
* Secure Data Erasure: Implements data sanitization techniques compliant with NIST SP 800-88 (Clean and Purge) standards to ensure data is irrecoverable.

* Cross-Platform Support: A single codebase that compiles and runs natively on Windows, macOS, and Linux.

* Intuitive User Interface: A clean, modern, and easy-to-navigate UI built with QML, designed for users of all technical skill levels.

* Verifiable Certificates: Automatically generates a digitally signed PDF certificate upon each successful wipe, providing an auditable record of data destruction.

* Automatic Drive Detection: Scans the host system and displays a list of all connected, writable storage devices.

* Real-time Progress: A detailed progress bar shows the status of the wipe process, including the remaining data and a time-to-completion estimate.

## 🛠️ Technology Stack
* Core Logic: C++

* Framework: Qt 6 (utilizing Qt Core, Gui, Quick, Widgets, and Pdf modules)

* User Interface: QML (Qt Quick)

* Build System: CMake

## 📋 Usage
* Launch the SecureWipe application.

* From the home screen, click "Wipe your Device".

* On the "Select the drive to Wipe" page, check the box next to the drive(s) you wish to sanitize.

* Click "Wipe Selected" to erase only the checked drives, or "Wipe All" to erase all listed drives.
  NIST SP 800-88 ATA Secure Deletion Tool

Enterprise-grade data sanitization tool implementing NIST SP 800-88 Rev. 1 guidelines for ATA devices (SATA HDDs and SSDs).

Overview
This tool provides hardware-based secure deletion for ATA devices using native drive commands, addressing limitations of software-only solutions. It implements the three NIST sanitization levels with automatic device capability detection and compliance certificate generation.

Features
NIST Compliance: Implements CLEAR, PURGE, and DESTROY sanitization levels
Hardware Commands: Uses ATA SECURITY ERASE UNIT and SANITIZE commands
Device Detection: Automatic capability detection for optimal sanitization method
Audit Trail: Generates NIST-compliant certificates for compliance documentation
Device Type Aware: Handles both SSDs and HDDs with appropriate methods
Supported Devices
SATA HDDs (Hard Disk Drives)
SATA SSDs (Solid State Drives)
NVMe SSDs
IDE/PATA drives
NOT Supported:

USB drives (ATA passthrough not reliable)
SCSI devices
NIST Sanitization Levels
CLEAR
Protection: Against basic data recovery tools
Method: ATA SECURITY ERASE UNIT
Use Case: Internal reuse within organization
Reusable: Yes
PURGE
Protection: Against advanced laboratory recovery techniques
Method: ATA SANITIZE commands or Enhanced Security Erase
Use Case: Media leaving organizational control
Reusable: Yes
DESTROY
Protection: Against nation-state level threats
Method: Physical destruction guidance
Use Case: Highest security requirements
Reusable: No (media is destroyed)
Installation
Prerequisites
# Required packages
sudo apt install build-essential gcc

# Optional: for examining ATA capabilities
sudo apt install hdparm smartmontools
Build
make
Clean
make clean
Usage
WARNING: This tool PERMANENTLY DELETES all data. There is no recovery.

Basic Usage
# Root privileges required
sudo ./jd <device> <method>
Examples
# CLEAR level sanitization
sudo ./jd /dev/sda clear

# PURGE level sanitization
sudo ./jd /dev/sdb purge

# Physical destruction guidance
sudo ./jd /dev/sdc destroy
Safety Confirmation
The tool requires explicit confirmation before proceeding:

Type 'CONFIRM NIST SANITIZATION' to proceed:
Device Frozen State
ATA drives may be in "security frozen" state, preventing security commands.

Solutions:

Hot-plug the SATA cable while system is running
Suspend and resume the system:
sudo systemctl suspend
# Wake system, then run tool
Certificate Generation
After successful sanitization, a certificate is generated:

NIST_800-88_ATA_<device>_Certificate_<timestamp>.txt
The certificate includes:

Device identification (model, serial, firmware)
Sanitization method and level
Timestamp and operator information
Compliance statement
Architecture
main.c              - CLI interface and orchestration
├── detectDevice.c  - ATA device capability detection
├── nist.c          - NIST sanitization level implementation
└── ata.c           - Low-level ATA command execution
Technical Details
ATA Commands Used
0xEC: IDENTIFY DEVICE - Device capability detection
0xF1: SECURITY SET PASSWORD - Password initialization
0xF2: SECURITY ERASE UNIT - Standard secure erase
0xB4: SANITIZE DEVICE - Advanced sanitization (Block Erase, Crypto Scramble)
SCSI Wrapper
Uses ATA PASS-THROUGH (16) command (0x85) to send ATA commands through SCSI layer.

Limitations
Software fallback: No software overwriting fallback when hardware commands fail
USB devices: Most USB-to-SATA adapters block ATA passthrough
NVMe drives: Require different tooling (nvme-cli)
Hidden areas: Some firmware-controlled areas may not be accessible
Security Considerations
Requires root privileges
Direct hardware access to storage devices
Bypasses filesystem and OS-level protections
Irreversible data destruction
Compliance
This tool follows:

NIST SP 800-88 Rev. 1 "Guidelines for Media Sanitization"
ATA/ATAPI Command Set standards
Industry best practices for data sanitization
Troubleshooting
"Drive is frozen"
Hot-plug SATA cable or suspend/resume system
"Failed to identify ATA device"
Verify device is SATA/IDE, not USB or NVMe
Check device permissions and root access
"SANITIZE commands failed"
Older drives may not support SANITIZE commands
Falls back to SECURITY ERASE UNIT
"Command not supported"
Check device capabilities with: sudo hdparm -I /dev/sdX
Legal Notice
This tool is designed for legitimate data sanitization purposes. Users are responsible for:

Ensuring proper authorization before sanitizing devices
Compliance with organizational data retention policies
Following applicable laws and regulations
Maintaining proper chain of custody documentation
License
This project is intended for educational and enterprise use. Ensure compliance with your organization's policies and applicable regulations.

Contributing
For bug reports or feature requests, ensure you include:

Device model and type (HDD/SSD)
Output of sudo hdparm -I /dev/sdX
Complete error messages
Operating system and kernel version
References
NIST SP 800-88 Rev. 1
ATA/ATAPI Command Set
SCSI Primary Commands
Disclaimer
DATA DESTRUCTION IS PERMANENT AND IRREVERSIBLE. Always verify device selection and maintain backups before sanitization. The authors assume no liability for data loss or hardware damage resulting from use of this tool.

* Monitor the real-time progress on the wipe progress page.

* Once completed, you will be taken to a confirmation page. Click "View Certificates" to see a list of all generated erasure certificates.

* From the certificates page, you can download a PDF copy of any certificate or delete it.
