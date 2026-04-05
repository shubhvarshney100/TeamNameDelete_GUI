import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    signal backClicked

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 50

        Text {
            text: "Certificates"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        // TableView requires Qt 6.x
        TableView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            model: [
                { date: "11.11.2026", drive: "Drive 1", driveSize: "1 TB", fileSize: "5 MB" },
                { date: "28.09.2026", drive: "Drive 2", driveSize: "1 TB", fileSize: "6 MB" },
                { date: "11.11.2026", drive: "Drive 1", driveSize: "1 TB", fileSize: "3 MB" }
            ]

            delegate: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                border.color: "#ecf0f1"
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    text: model[model.column]
                }
            }

            // Columns
            TableColumn { role: "date"; title: "Date"; width: 150 }
            TableColumn { role: "drive"; title: "Drive"; width: 150 }
            TableColumn { role: "driveSize"; title: "Drive Size"; width: 150 }
            TableColumn { role: "fileSize"; title: "File Size"; width: 150 }
        }

        CustomButton {
            text: "Back to Home"
            buttonColor: "#95a5a6"
            hoverColor: "#7f8c8d"
            onClicked: root.backClicked()
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
