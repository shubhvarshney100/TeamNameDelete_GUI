import QtQuick
import QtQuick.Layouts

Item {
    id: root
    signal wipeDeviceClicked

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "SecureWipe"
            font.pixelSize: 72
            font.bold: true
            color: "#333"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Your one click Trustworthy IT Asset Recycling!"
            font.pixelSize: 16
            color: "#555"
            Layout.alignment: Qt.AlignHCenter
        }

        CustomButton {
            text: "Wipe your Device"
            onClicked: root.wipeDeviceClicked()
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
        }
    }
}

// Reusable Button Component
import QtQuick.Controls

Button {
    id: control
    property color buttonColor: "#3498db"
    property color hoverColor: "#2980b9"

    text: "Button"
    font.pixelSize: 16
    font.bold: true

    background: Rectangle {
        color: control.hovered ? hoverColor : buttonColor
        radius: 8
    }

    contentItem: Text {
        text: control.text
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    padding: 15
    leftPadding: 30
    rightPadding: 30
}
