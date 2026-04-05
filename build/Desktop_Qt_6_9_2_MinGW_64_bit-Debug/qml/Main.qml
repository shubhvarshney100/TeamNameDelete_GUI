import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.securewipe.backend 1.0

ApplicationWindow {
    id: root
    width: 800
    height: 600
    visible: true
    title: qsTr("SecureWipe")
    color: "#FFFFFF"

    // Instantiate our C++ backend
    DriveManager {
        id: driveManager

        // Listen for the wipeComplete signal from C++
        onWipeComplete: (success) => {
            // When wipe finishes, go to the completion page
            stackLayout.currentIndex = 3 // Index of CompletionPage
        }
    }

    // Header shown on most pages
    Rectangle {
        id: header
        width: parent.width
        height: 50
        color: "#3498db"
        visible: stackLayout.currentIndex > 0 // Hide on landing page

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20
            spacing: 15

            Text { text: "🏠"; font.pixelSize: 24; MouseArea { anchors.fill: parent; onClicked: stackLayout.currentIndex = 0 } }
            Text { text: "🗑️"; font.pixelSize: 24; MouseArea { anchors.fill: parent; onClicked: {} /* TODO */ } }
            Text { text: "📋"; font.pixelSize: 24; MouseArea { anchors.fill: parent; onClicked: stackLayout.currentIndex = 4 } }
        }
    }


    // A StackLayout is perfect for managing different pages
    StackLayout {
        id: stackLayout
        anchors.top: header.bottom
        anchors.bottom: footer.top
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 0 // Start at the landing page

        LandingPage {
            onWipeDeviceClicked: stackLayout.currentIndex = 1
        }
        DriveSelectionPage {
            // Pass the C++ manager to the page
            manager: driveManager
            onStartWipe: stackLayout.currentIndex = 2
        }
        WipeProgressPage {
            manager: driveManager
        }
        CompletionPage {
            manager: driveManager
            onViewCertificatesClicked: stackLayout.currentIndex = 4
        }
        CertificatesPage {
             onBackClicked: stackLayout.currentIndex = 0
        }
    }

    // Footer
    Rectangle {
        id: footer
        width: parent.width
        height: 30
        anchors.bottom: parent.bottom
        color: "#3498db"
        Text {
            text: "© 2025 SecureWipe • Safe & Secure"
            anchors.centerIn: parent
            color: "white"
        }
    }
}
