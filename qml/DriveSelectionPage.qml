import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#f0f4f8"

    // This signal is used to tell the main window to start the wipe process
    signal startWipe(variant drives)

    // When this page becomes visible, refresh the drive list
    Component.onCompleted: {
        driveManager.refreshDrives()
    }

    // Function to get the paths of all selected drives
    function getSelectedDrives() {
        let selected = []
        if (driveView.model) {
            for (let i=0; i < driveView.model.length; ++i) {
                if (driveView.model[i].checked) {
                    selected.push(driveView.model[i].path)
                }
            }
        }
        return selected
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Text {
            text: "Select the drive to Wipe"
            font.pixelSize: 36
            font.bold: true
            color: "#1e293b"
            Layout.alignment: Qt.AlignHCenter
        }

        ListView {
            id: driveView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 15

            model: driveManager.driveModel

            delegate: Frame {
                width: parent.width
                padding: 15
                background: Rectangle {
                    color: "#ffffff"
                    radius: 8
                    border.color: "#e2e8f0"
                }

                RowLayout {
                    width: parent.width

                    CheckBox {
                        id: driveCheckBox
                        checked: modelData.checked
                        onCheckedChanged: modelData.checked = checked
                    }

                    Column {
                        Layout.fillWidth: true
                        Text {
                            text: modelData.name
                            font.bold: true
                            font.pixelSize: 16
                            color: "#1e293b"
                        }
                        Text {
                            text: `Type: ${modelData.type} | ${modelData.size}`
                            font.pixelSize: 14
                            color: "#475569"
                        }
                    }
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            // --- Custom "Wipe Selected" Button ---
            Item {
                implicitWidth: wipeSelectedText.implicitWidth + 60
                implicitHeight: wipeSelectedText.implicitHeight + 30

                Rectangle {
                    anchors.fill: parent
                    radius: 30
                    color: wipeSelectedMouseArea.pressed ? "#3c61ab" : wipeSelectedMouseArea.hovered ? "#7aaeff" : "#649cf1"
                }
                Text {
                    id: wipeSelectedText
                    anchors.centerIn: parent
                    text: "Wipe Selected"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                }
                MouseArea {
                    id: wipeSelectedMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var selected = getSelectedDrives()
                        if (selected.length > 0) {
                            root.startWipe(selected)
                        }
                    }
                }
            }

            // --- Custom "Wipe All" Button ---
            Item {
                implicitWidth: wipeAllText.implicitWidth + 60
                implicitHeight: wipeAllText.implicitHeight + 30

                Rectangle {
                    anchors.fill: parent
                    radius: 30
                    color: wipeAllMouseArea.pressed ? "#3c61ab" : wipeAllMouseArea.hovered ? "#7aaeff" : "#649cf1"
                }
                Text {
                    id: wipeAllText
                    anchors.centerIn: parent
                    text: "Wipe All"
                    font.pixelSize: 16
                    font.bold: true
                    color: "black"
                }
                MouseArea {
                    id: wipeAllMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        var allDrives = []
                        if(driveView.model) {
                            for (var i = 0; i < driveView.model.length; ++i) {
                                allDrives.push(driveView.model[i].path)
                            }
                        }
                        if (allDrives.length > 0) {
                            root.startWipe(allDrives)
                        }
                    }
                }
            }
        }
    }
}

