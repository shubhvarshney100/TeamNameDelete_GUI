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

* Monitor the real-time progress on the wipe progress page.

* Once completed, you will be taken to a confirmation page. Click "View Certificates" to see a list of all generated erasure certificates.

* From the certificates page, you can download a PDF copy of any certificate or delete it.
