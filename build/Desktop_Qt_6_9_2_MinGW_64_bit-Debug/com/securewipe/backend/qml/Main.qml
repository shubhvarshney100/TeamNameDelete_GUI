import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.securewipe.backend 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 800
    height: 600
    title: "SecureWipe"

    background: Rectangle {
        color: "#f0f4f8"
    }

    // This exposes our C++ DriveManager to all QML files
    DriveManager {
        id: driveManager

        // --- DEFINITIVE FIX: Updated the signal handler to match the new C++ signal ---
        // This now correctly receives all three pieces of data (progress, size, time)
        // and passes them to the function on the WipeProgressPage.
        onWipeProgressUpdated: (progress, remainingSize, remainingTime) => {
            wipeProgressPage.updateProgress(progress, remainingSize, remainingTime)
        }

        onWipeCompleted: (details) => {
            completionPage.completionDetails = details
            stackLayout.currentIndex = 3 // Switch to CompletionPage
        }
    }

    header: Rectangle {
        id: header
        width: parent.width
        height: 50
        color: "#649cf1"

        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 15

            Button {
                text: "Home"
                font.pixelSize: stackLayout.currentIndex === 0 ? 16 : 14
                font.bold: stackLayout.currentIndex === 0
                flat: true
                enabled: stackLayout.currentIndex !== 0
                opacity: enabled ? 1.0 : 0.5
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "black"
                }
                onClicked: stackLayout.currentIndex = 0
                background: Rectangle {
                    color: "transparent"
                }
            }
            Button {
                text: "Wipe"
                font.pixelSize: stackLayout.currentIndex === 1 ? 16 : 14
                font.bold: stackLayout.currentIndex === 1
                flat: true
                enabled: stackLayout.currentIndex !== 1
                opacity: enabled ? 1.0 : 0.5
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "black"
                }
                onClicked: stackLayout.currentIndex = 1
                background: Rectangle {
                    color: "transparent"
                }
            }
            Button {
                text: "My Certificates"
                font.pixelSize: stackLayout.currentIndex === 4 ? 16 : 14
                font.bold: stackLayout.currentIndex === 4
                flat: true
                enabled: stackLayout.currentIndex !== 4
                opacity: enabled ? 1.0 : 0.5
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "black"
                }
                onClicked: stackLayout.currentIndex = 4
                background: Rectangle {
                    color: "transparent"
                }
            }
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: 0

        LandingPage {
            onWipeDeviceClicked: stackLayout.currentIndex = 1
        }
        DriveSelectionPage {
            id: driveSelectionPage
            Connections {
                target: driveSelectionPage
                function onStartWipe(drives) {
                    driveManager.startWipeProcess(drives)
                    stackLayout.currentIndex = 2
                }
            }
        }
        WipeProgressPage { id: wipeProgressPage }
        CompletionPage {
            id: completionPage
            onViewCertificatesClicked: stackLayout.currentIndex = 4
        }
        CertificatesPage {
            onBackClicked: stackLayout.currentIndex = 0
        }
    }

    footer: Rectangle {
        width: parent.width
        height: 30
        color: "#262626"

        Text {
            anchors.centerIn: parent
            text: "© 2025 SecureWipe • Safe & Secure"
            font.pixelSize: 12
            color: "white"
        }
    }
}

