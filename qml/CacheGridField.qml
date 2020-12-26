import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Item {
    property bool validField: false
    property string tagField: ""
    property int blockSize: 1

    readonly property int rectHeightMargin: 8
    readonly property int wordSize: 32

    property int set: 0
    property int way: 0

    property alias fontLabels: labelValidTitle.font
    property font fontFields

    implicitWidth: fontMetrics.averageCharacterWidth * wordSize + 20
    implicitHeight: 2*fontMetrics.height + rectHeightMargin

    Rectangle {
        id: rectValid
        width: fontMetrics.averageCharacterWidth + 20
        height: fontMetrics.height + rectHeightMargin
        anchors {
            left: parent.left
            right: rectTag.left
            bottom: parent.bottom
        }
        color: "transparent"
        border.width: 2
        border.color: Material.color(Material.Grey, Material.Shade800)
    }

    Label {
        id: labelValid
        anchors.fill: rectValid
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: fontFields
        text: validField ? "1" : "0"
    }

    Label {
        id: labelValidTitle
        anchors {
            left: rectValid.left
            right: rectValid.right
            bottom: rectValid.top
            top: parent.top
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "V"
    }

    Rectangle {
        id: rectTag
        height: fontMetrics.height + rectHeightMargin
        anchors {
            left: rectValid.right
            right: parent.right
            bottom: parent.bottom
        }
        color: "transparent"
        border.width: 2
        border.color: Material.color(Material.Grey, Material.Shade800)
    }

    Label {
        id: labelTag
        anchors.fill: rectTag
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: fontFields
        text: tagField
    }

    Label {
        id: labelTagTitle
        anchors {
            left: rectTag.left
            right: rectTag.right
            bottom: rectTag.top
            top: parent.top
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font: labelValidTitle.font
        text: "TAG"
    }

    FontMetrics {
        id: fontMetrics
        font: labelValid.font
    }
}
