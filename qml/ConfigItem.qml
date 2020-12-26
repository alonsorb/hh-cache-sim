import QtQuick 2.15
import QtQuick.Controls 2.5

Item {
    property alias label: label.text
    property alias value: textField.text
    property alias font: label.font
    implicitWidth: 100
    implicitHeight: 30

    Label {
        id: label
        anchors.left: parent.left
        width: 0.4 * parent.width
        height: parent.height
        verticalAlignment: Text.AlignVCenter
    }

    TextField {
        id: textField
        anchors.right: parent.right
        width: 0.4 * parent.width
        height: parent.height
        font: label.font
        validator: IntValidator {
            bottom: 0
        }
        horizontalAlignment: Text.AlignHCenter
    }
}
