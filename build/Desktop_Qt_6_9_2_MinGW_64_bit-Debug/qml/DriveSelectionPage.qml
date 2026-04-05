import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property var manager // This will be our C++ DriveManager instance
    signal startWipe

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 50

        Text {
            text: "Select the drive to Wipe"
            font.pixelSize: 24
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignHCenter
        }

        ListView {
            id: driveView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: manager.driveModel
            spacing: 15
            delegate: CheckBoxDelegate {}

            function getSelectedDrives() {
                let selected = []
                for(let i=0; i < count; i++) {
                    let item = itemAtIndex(i)
                    if (item.checked) {
                        selected.push(model[i])
                    }
                }
                return selected
            }

            function selectAllDrives() {
                 let allDrives = []
                 for(let i=0; i < count; i++) {
                    let item = itemAtIndex(i)
                    item.checked = true
                    allDrives.push(model[i])
                 }
                 return allDrives
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            CustomButton {
                text: "Wipe Selected"
                buttonColor: "#95a5a6"
                hoverColor: "#7f8c8d"
                onClicked: {
                    let selected = driveView.getSelectedDrives()
                    if (selected.length > 0) {
                        manager.startWiping(selected)
                        root.startWipe()
                    }
                }
            }

            CustomButton {
                text: "Wipe All"
                onClicked: {
                    let allDrives = driveView.selectAllDrives();
                    if(allDrives.length > 0) {
                        manager.startWiping(allDrives)
                        root.startWipe()
                    }
                }
            }
        }
    }
}

import QtQuick.Controls

Rectangle {
    id: delegateRoot
    property bool checked: checkBox.checked
    width: parent.width
    height: 80
    color: "#f0f8ff"
    border.color: "#d0e0ff"
    radius: 8

    CheckBox {
        id: checkBox
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        text: modelData.displayName // e.g., "DRIVE1 (C:/)"

        indicator: Rectangle {
            implicitWidth: 20
            implicitHeight: 20
            x: checkBox.leftPadding
            y: parent.height / 2 - height / 2
            radius: 3
            border.color: checkBox.checked ? "#3498db" : "#bdc3c7"
            border.width: 2

            Rectangle {
                width: 10
                height: 10
                x: 5
                y: 5
                radius: 2
                color: "#3498db"
                visible: checkBox.checked
            }
        }

        contentItem: Text {
            leftPadding: checkBox.indicator.width + checkBox.spacing
            text: checkBox.text
            font.pixelSize: 16
            color: "#333"
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    Text {
        text: modelData.details // "Type: NTFS, Size: 1TB"
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.verticalCenter: parent.verticalCenter
        color: "#7f8c8d"
    }
}
