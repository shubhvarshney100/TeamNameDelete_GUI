import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    property var manager

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: manager.wipeStatusText
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        ProgressBar {
            id: progressBar
            from: 0
            to: 100
            value: manager.wipeProgress
            Layout.fillWidth: true
            Layout.minimumWidth: 400

            background: Rectangle {
                radius: 5
                color: "#ecf0f1"
                border.color: "#bdc3c7"
            }

            contentItem: Item {
                 Rectangle {
                    width: progressBar.visualPosition * progressBar.width
                    height: progressBar.height
                    color: "#3498db"
                    radius: 5
                }
                Text {
                    anchors.centerIn: parent
                    text: progressBar.value.toFixed(0) + "%"
                    color: progressBar.value < 40 ? "#333" : "white"
                }
            }
        }
    }
}
