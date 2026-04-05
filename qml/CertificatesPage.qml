import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#f0f4f8"

    signal backClicked()

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Text {
            text: "Certificates"
            font.pixelSize: 36
            font.bold: true
            color: "#1e293b"
            Layout.alignment: Qt.AlignHCenter
        }

        // Header using RowLayout with explicit IDs for each column
        RowLayout {
            id: tableHeader
            Layout.fillWidth: true
            spacing: 15

            Text { id: dateHeader; text: "Date"; font.bold: true; color: "#475569"; Layout.fillWidth: true }
            Text { id: timeHeader; text: "Timestamp"; font.bold: true; color: "#475569"; Layout.fillWidth: true }
            Text { id: driveHeader; text: "Drive Name"; font.bold: true; color: "#475569"; Layout.fillWidth: true }
            Text { id: driveSizeHeader; text: "Drive Size"; font.bold: true; color: "#475569"; Layout.fillWidth: true }
            Text { id: fileSizeHeader; text: "File Size"; font.bold: true; color: "#475569"; Layout.fillWidth: true }
            Text { id: actionsHeader; text: "Actions"; font.bold: true; color: "#475569"; Layout.alignment: Qt.AlignHCenter; Layout.preferredWidth: 150 }
        }

        ListView {
            id: certificateView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 10
            // Bind the model to the dynamic list from our C++ backend
            model: driveManager.certificateModel

            delegate: Rectangle {
                width: parent.width
                height: 60
                color: "white"
                radius: 8
                border.color: "#e2e8f0"

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text { text: modelData.date; color: "#1e293b"; width: dateHeader.width }
                    Text { text: modelData.timestamp; color: "#1e293b"; width: timeHeader.width }
                    Text { text: modelData.drive; color: "#1e293b"; width: driveHeader.width }
                    Text { text: modelData.driveSize; color: "#1e293b"; width: driveSizeHeader.width }
                    Text { text: modelData.fileSize; color: "#1e293b"; width: fileSizeHeader.width }

                    RowLayout {
                        width: actionsHeader.width
                        height: parent.height
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 10

                        Button {
                            text: "Download"
                            flat: true
                            background: Rectangle { color: "#258f00"; radius: 4 }
                            contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 12 }
                            // FIX: Use 'index' to refer to the row number, not 'modelData.index'
                            onClicked: driveManager.downloadCertificate(index)
                        }
                        Button {
                            text: "Delete"
                            flat: true
                            background: Rectangle { color: "#e74c3c"; radius: 4 }
                            contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 12 }
                             // FIX: Use 'index' to refer to the row number, not 'modelData.index'
                            onClicked: driveManager.deleteCertificate(index)
                        }
                    }
                }
            }
             // Show a message if there are no certificates
            Text {
                anchors.centerIn: parent
                text: "No certificates have been generated yet."
                font.pixelSize: 16
                color: "#94a3b8"
                // FIX: Correctly check the model size
                visible: certificateView.model ? certificateView.model.count === 0 : true
            }
        }

        // Custom "Back to Home" Button
        Item {
            id: buttonContainer
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            implicitWidth: buttonText.implicitWidth + 60
            implicitHeight: buttonText.implicitHeight + 30

            Rectangle {
                anchors.fill: parent
                radius: 30
                color: mouseArea.pressed ? "#95a5a6" : mouseArea.hovered ? "#bdc3c7" : "#649cf1"
            }
            Text {
                id: buttonText
                anchors.centerIn: parent
                text: "Back to Home"
                font.pixelSize: 16
                font.bold: true
                color: "black"
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.backClicked()
            }
        }
    }
}

