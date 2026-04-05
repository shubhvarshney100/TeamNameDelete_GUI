import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property var manager
    signal viewCertificatesClicked

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Wipe Completed Successfully!"
            font.pixelSize: 24
            font.bold: true
            color: "#27ae60"
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumWidth: 400
            color: "#f0f8ff"
            border.color: "#d0e0ff"
            radius: 8
            padding: 15

            Text {
                width: parent.width
                text: manager.completionDetails
                wrapMode: Text.WordWrap
            }
        }


        Text {
            text: "Your data is wiped! Certificate of confirmation is generated."
            font.pixelSize: 16
            font.bold: true
            color: "#27ae60"
            Layout.alignment: Qt.AlignHCenter
        }

        CustomButton {
            text: "View Certificates"
            onClicked: root.viewCertificatesClicked()
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
        }
    }
}
