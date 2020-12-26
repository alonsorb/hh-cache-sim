import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Item {
    property real hitRate: 0.5
    property alias font: labelHit.font

    width: 400
    height: 30

    Label {
        id: labelHit
        anchors.left: parent.left
        width: 0.2 * parent.width
        height: parent.height
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Hit\n" + (100*hitRate).toFixed() + " %")
    }

    ProgressBar {
        id: progressBar
        anchors {
            left: labelHit.right
            right: labelMiss.left
            top: parent.top
            bottom: parent.bottom
        }
        background: Rectangle {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            height: 0.2 * parent.height
            color: Material.color(Material.Red, Material.Shade300)
        }
        contentItem: Item {
            implicitWidth: 10
            implicitHeight: parent.height
            Rectangle {
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                width: progressBar.visualPosition * progressBar.width
                height: 0.2 * parent.height
                color: Material.color(Material.Blue, Material.Shade300)
            }
        }
        width: 0.6 * parent.width
        height: parent.height
        value: hitRate
    }

    Label {
        id: labelMiss
        anchors.right: parent.right
        width: 0.2 * parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: labelHit.font
        text: qsTr("Miss\n" + (100*(1-hitRate)).toFixed() + " %")
    }
}
