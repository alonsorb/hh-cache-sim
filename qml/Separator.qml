import QtQuick 2.0
import QtQuick.Controls.Material 2.3

Rectangle {
    width: parent.width
    implicitWidth: 100
    implicitHeight: 20
    color: "transparent"
    Rectangle {
        width: 1 * parent.width
        height: 1
        anchors.centerIn: parent
        color: Material.color(Material.Grey)
    }
}
