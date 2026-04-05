import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#f0f4f8"

    property string completionDetails: "No details available."
    signal viewCertificatesClicked()

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: parent.width * 0.8

        Text {
            text: "Wipe Completed Successfully!"
            font.pixelSize: 36
            font.bold: true
            color: "#258f00" // A success green color
            Layout.alignment: Qt.AlignHCenter
        }

        Frame {
            Layout.fillWidth: true
            Layout.minimumHeight: 150
            padding: 15
            background: Rectangle {
                color: "#ffffff"
                radius: 8
                border.color: "#e2e8f0"
            }

            Text {
                width: parent.width
                text: root.completionDetails
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                color: "#334155"
            }
        }

        Text {
            text: "Your data is wiped! Certificate of confirmation is generated."
            font.pixelSize: 16
            font.bold: true
            color: "#258f00"
            Layout.alignment: Qt.AlignHCenter
        }

        // --- Custom "View Certificates" Button ---
        Item {
            id: buttonContainer
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            implicitWidth: buttonText.implicitWidth + 60
            implicitHeight: buttonText.implicitHeight + 30

            Rectangle {
                anchors.fill: parent
                radius: 30
                color: mouseArea.pressed ? "#3c61ab" : mouseArea.hovered ? "#7aaeff" : "#649cf1"
            }

            Text {
                id: buttonText
                anchors.centerIn: parent
                text: "View Certificates"
                font.pixelSize: 16
                font.bold: true
                color: "black"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.viewCertificatesClicked()
            }
        }
    }
}

