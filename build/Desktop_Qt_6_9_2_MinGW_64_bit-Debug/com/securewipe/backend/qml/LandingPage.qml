import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#f0f4f8" // A light background color

    signal wipeDeviceClicked()

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "SecureWipe"
            font.pixelSize: 72
            font.bold: true
            color: "#1e293b" // Dark slate color for text
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Your one click Trustworthy IT Asset Recycling!"
            font.pixelSize: 18
            color: "#475569" // Lighter slate color for subtitle
            Layout.alignment: Qt.AlignHCenter
        }

        // --- DEFINITIVE FIX: Custom button built with Rectangle and MouseArea ---
        // This approach gives us full control and prevents any default styling issues.
        Item {
            id: buttonContainer
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20

            // Set the size of our button based on the text and desired padding
            implicitWidth: buttonText.implicitWidth + 80 // 40px padding left/right
            implicitHeight: buttonText.implicitHeight + 40 // 20px padding top/bottom

            // The visual background of the button
            Rectangle {
                anchors.fill: parent
                radius: 30 // Highly-rounded corners that will always be visible

                // Color changes based on the MouseArea's state
                color: mouseArea.pressed ? "#3c61ab" : mouseArea.hovered ? "#7aaeff" : "#649cf1"
            }

            // The button's text label
            Text {
                id: buttonText
                anchors.centerIn: parent
                text: "Wipe your Device"
                font.pixelSize: 20
                font.bold: true
                color: "black"
            }

            // The interactive area that detects clicks and hovers
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.wipeDeviceClicked()
            }
        }
    }
}
