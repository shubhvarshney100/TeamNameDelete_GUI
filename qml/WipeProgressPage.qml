import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#f0f4f8"

    // Properties to hold the data from the C++ backend
    property int progressPercent: 0
    property string remainingSizeText: "Calculating..."
    property string remainingTimeText: "Calculating..."

    // This is called by the C++ backend to update the progress
    function updateProgress(progress, remainingSize, remainingTime) {
        progressPercent = progress
        remainingSizeText = remainingSize
        remainingTimeText = remainingTime
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "Wiping in Progress..."
            font.pixelSize: 36
            font.bold: true
            color: "#1e293b"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Please do not turn off your device. This process is irreversible."
            font.pixelSize: 16
            color: "#e74c3c"
            Layout.alignment: Qt.AlignHCenter
        }

        // --- Custom Progress Bar ---
        Frame {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width * 0.8
            Layout.preferredHeight: 100
            padding: 0
            background: Rectangle {
                color: "#e2e8f0" // Background color of the bar
                radius: 15
            }

            // The blue progress indicator
            Rectangle {
                width: parent.width * (root.progressPercent / 100.0)
                height: parent.height
                color: "#649cf1"
                radius: 15

                // Animate the width change for a smooth effect
                Behavior on width {
                    NumberAnimation { duration: 100; easing.type: Easing.InOutQuad }
                }
            }

            // --- Text Overlay on the Progress Bar ---
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20

                // Percentage Text
                Text {
                    text: root.progressPercent + "%"
                    font.pixelSize: 18
                    font.bold: true
                    color: "black"
                }

                // Spacer to push the other text to the right
                Item { Layout.fillWidth: true }

                // Remaining Size and Time Text
                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 5
                    Text {
                        text: "Remaining: " + root.remainingSizeText
                        font.pixelSize: 14
                        color: "black"
                        Layout.alignment: Qt.AlignRight
                    }
                    Text {
                        text: "Time Left: " + root.remainingTimeText
                        font.pixelSize: 14
                        color: "black"
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }
    }
}

