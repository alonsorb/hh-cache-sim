import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Item {
    id: item
    property int numSets: 1
    property int numWays: 1
    property int blockSize: 1

    property alias list: fieldsList
    property alias fontLabels: labelWays.font
    property font fontFields

    ListModel {
        id: fieldsList
    }

    function getField (set, way) {
        return fieldsList.get(set*numWays + way);
    }

    function createGrid() {
        fieldsList.clear()
        for (var i = 0; i < numSets; i++) {
            for (var j = 0; j < numWays; j++) {
                fieldsList.append({"_set": i, "_way": j, "_blockSize": blockSize,
                                  "_validField": false, "_tagField": ""})
            }
        }
    }

    // TODO replace negative offsets
    Label {
        id: labelWays
        y: -20
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Ways")
    }

    Label {
        id: labelSets
        x: -20
        anchors.verticalCenter: parent.verticalCenter
        font: labelWays.font
        text: qsTr("Sets")
        rotation: -90
    }

    // TODO colSets and rowWays should be always visible (even when scrolling)
    ScrollView {
        anchors.fill: parent
        clip: true
        contentWidth: grid.x + grid.width
        contentHeight: grid.y + grid.height
        ColumnLayout {
            id: colSets
            spacing: grid.rowSpacing
            anchors {
                left: parent.left
                right: grid.left
                top: grid.top
                bottom: grid.bottom
            }
            Repeater {
                model: numSets
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    Label {
                        id: labelNumSets
                        anchors {
                            right: parent.right
                            rightMargin: 20
                            bottom: parent.bottom
                        }
                        font: fontLabels
                        text: index
                    }
                }
            }
        }

        RowLayout {
            id: rowWays
            spacing: grid.columnSpacing
            anchors {
                left: grid.left
                right: grid.right
                top: parent.top
                bottom: grid.top
            }
            Repeater {
                model: numWays
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    Label {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 10
                        }
                        font: fontLabels
                        text: index
                    }
                }
            }
        }

        GridLayout {
            id: grid
            x: 40
            y: 40
            rows: numSets
            columns: numWays
            columnSpacing: 20
            rowSpacing: 10
            Repeater {
                model: fieldsList
                CacheGridField {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    set: _set
                    way: _way
                    blockSize: _blockSize
                    validField: _validField
                    tagField: _tagField
                    fontLabels.family: item.fontLabels.family
                    fontFields: item.fontFields ? item.fontFields : item.fontLabels
                }
            }
        }

    }
}
