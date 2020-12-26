import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Item {
    property alias lineCount: textArea.lineCount
    property alias text: textArea.text
    property alias font: textArea.font
    property int currentLine: 0

    implicitWidth: 200
    implicitHeight: 400

    // TODO line highlight fails if textArea is bigger than the default size
    Rectangle {
        x: 0
        y: textArea.y + currentLine * fontMetrics.height + 8
        width: textArea.width
        height: fontMetrics.height
        visible: textArea.length > 0 && currentLine < lineCount
        color: Material.color(Material.Red, Material.Shade50)
    }

    function getCurrentLine() {
        var lines = textArea.text.split('\n')
        if (textArea.length && currentLine < lines.length) {
            return lines[currentLine]
        } else {
            return ""
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true
        TextArea {
            id: textArea
            placeholderText: qsTr("Put your memory accesses\nhere, for example:\n\n0x000000F4\n0x000000F8\n0x000000FC")
            selectByMouse: true
        }
    }

    FontMetrics {
        id: fontMetrics
        font: textArea.font
    }
}
