import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import com.cache 1.0

ApplicationWindow {

    readonly property int defaultNumSets: 8
    readonly property int defaultNumWays: 2
    readonly property int defaultBlockSzie: 1
    readonly property real margins: 30
    property bool configChanegd: false

    id: window
    visible: true
    width: 1100
    height: 700

    minimumWidth: 1100
    minimumHeight: 700


    title: qsTr("Harris & Harris Cache Simulator")

    // BACKEND

    Cache {
        id: cache
        numSets: defaultNumSets
        numWays: defaultNumWays
        blockSize: defaultBlockSzie
        Component.onCompleted: {
            reset();
            layoutWarning.visible = false;
        }
        onCacheUpdated: {
            for (var i = 0; i < cacheGrid.numSets; i++) {
                for (var j = 0; j < cacheGrid.numWays; j++) {
                    var field = cacheGrid.getField(i, j);
                    field._validField = cache.getValidField(i, j);
                    field._tagField = cache.getTagField(i, j);
                    if (field._tagField.length > 0) {
                        var bBlockSize = Math.log2(cacheGrid.blockSize);
                        field._tagField += "X".repeat(bBlockSize);
                    }
                }
            }
        }
        onHitRateChanged: {
            hitmissIndicator.hitRate = hitRate
        }
    }

    // FRONTEND

    FontLoader {
        id: fontRoboto
        source: "fonts/Roboto-Regular.ttf"
    }

    FontLoader {
        id: fontRobotoMono
        source: "fonts/RobotoMono-Regular.ttf"
    }

    RoundButton {
        anchors {
            right: parent.right
            rightMargin: 0
            top: parent.top
            topMargin: 0
        }
        width: 36
        height: 36
        background: Item {
            Image {
                source: "img/info.svg"
                sourceSize.width: parent.width
                sourceSize.height: parent.height
            }
            Rectangle {
                width: parent.width
                height: parent.height
                radius: 0.5 * height
                color: "transparent"
            }
        }
        onPressed: {
            popupInfo.open()
        }
    }

    Popup {
        id: popupConfigError
        anchors.centerIn: parent
        width: 500
        height: 300
        modal: true
        Image {
            id: iconErrorConfig
            source: "/img/error.svg"
            sourceSize.width: 140
            sourceSize.height: 140
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
        }
        Label {
            anchors {
                top: iconErrorConfig.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            font.family: fontRoboto.name
            font.pixelSize: 24
            text: qsTr("Invald cache configuration")
        }
    }

    Popup {
        id: popupInputError
        anchors.centerIn: parent
        width: 500
        height: 300
        modal: true
        Image {
            id: iconErrorInput
            source: "/img/error.svg"
            sourceSize.width: 140
            sourceSize.height: 140
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
        }
        Label {
            anchors {
                top: iconErrorInput.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            font.family: fontRoboto.name
            font.pixelSize: 24
            text: qsTr("Invald input")
        }
    }

    Popup {
        id: popupInfo
        anchors.centerIn: parent
        width: 500
        height: 300
        modal: true
        Label {
            anchors {
                top: parent.top
                topMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            font.family: fontRoboto.name
            font.pixelSize: 24
            //TODO add info
            text: qsTr("github.com/alonsorb/hh-cache-sim")
        }
    }

    RoundPane {
        id: paneConfig
        anchors {
            top: parent.top
            topMargin: window.margins
            left: parent.left
            leftMargin: window.margins
        }
        width: 300
        height: 340

        ColumnLayout {
            id: layoutSettings
            width: parent.width
            height: 0.3 * parent.height
            ConfigItem {
                id: configNumSets
                Layout.fillWidth: true
                Layout.minimumHeight: 40
                font.family: fontRoboto.name
                label: qsTr("Number of Sets")
                value: defaultNumSets
                onValueChanged: {
                    layoutWarning.visible = true
                }
            }
            ConfigItem {
                id: configNumWays
                Layout.fillWidth: true
                Layout.minimumHeight: 40
                font.family: fontRoboto.name
                label: qsTr("Number of Ways")
                value: defaultNumWays
                onValueChanged: {
                    layoutWarning.visible = true
                }
            }
            ConfigItem {
                id: configBlockSize
                Layout.fillWidth: true
                Layout.minimumHeight: 40
                font.family: fontRoboto.name
                label: qsTr("Block Size")
                value: defaultBlockSzie
                onValueChanged: {
                    layoutWarning.visible = true
                }
            }
        }
        RowLayout {
            id: layoutWarning
            width: parent.width
            height: 0.1 * parent.height
            anchors {
                top: layoutSettings.bottom
                topMargin: 60
            }
            visible: false

            Image {
                id: iconWarning
                source: "img/warning.svg"
                sourceSize.width: 24
                sourceSize.height: 24
            }
            Label {
                id: labelReset
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Changes will not be applied until reset")
                font.family: fontRoboto.name
            }
        }
        Button {
            id: buttonReset
            width: 100
            height: 60
            anchors {
                top: layoutWarning.bottom
                horizontalCenter: layoutWarning.horizontalCenter
            }
            font.family: fontRoboto.name
            text: qsTr("RESET")
            onPressed: {
                // TODO There has to be a better way of doing this
                var numSets = parseInt(configNumSets.value);
                var numWays = parseInt(configNumWays.value);
                var blockSize = parseInt(configBlockSize.value);
                if (isNaN(numSets) || isNaN(numWays) || isNaN (blockSize)) {
                    popupConfigError.open();
                    return;
                }
                if ((numSets < 1) || (numWays < 1) || (blockSize < 1)) {
                    popupConfigError.open();
                    return;
                }
                var bNumSets = Math.log2(numSets);
                var bNumWays = Math.log2(numWays);
                var bBlockSize = Math.log2(blockSize);
                if (!(bNumSets % 1 === 0) || !(bNumWays % 1 === 0) || !(bBlockSize % 1 === 0)) {
                    popupConfigError.open();
                    return;
                }
                cache.numSets = numSets;
                cache.numWays = numWays;
                cache.blockSize = blockSize;
                hitmissIndicator.hitRate = 0.5;
                addressTextInput.currentLine = 0;
                cacheGrid.createGrid();
                cache.reset();
                layoutWarning.visible = false;
            }
        }

        Separator {
            id: configSseparator
            width: parent.width
            height: 20
            anchors {
                top: buttonReset.bottom
                bottom: hitmissIndicator.top
            }
        }

        HitMissIndicator {
            id: hitmissIndicator
            width: parent.width
            anchors {
                bottom: parent.bottom
            }
            font.family: fontRoboto.name
        }
    }

    RoundPane {
        id: paneInputs
        anchors {
            top: paneConfig.bottom
            topMargin: window.margins
            left: paneConfig.left
            right: paneConfig.right
            bottom: parent.bottom
            bottomMargin: window.margins
        }

        RowLayout {
            id: rowRunButtons
            width: parent.width
            height: 60
            Button {
                id: buttonRun
                Layout.preferredWidth: 100
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                enabled: addressTextInput.currentLine < addressTextInput.lineCount && addressTextInput.text
                font.family: fontRoboto.name
                text: qsTr("RUN")
                onPressed: {
                    while (addressTextInput.currentLine < addressTextInput.lineCount) {
                        var line = addressTextInput.getCurrentLine();
                        var re = /0x[0-9A-Fa-f]{8}/g;
                        if (!re.test(line)) {
                            popupInputError.open()
                            return;
                        }
                        cache.request(parseInt(line));
                        addressTextInput.currentLine += 1;
                    }
                }
            }
            Button {
                id: buttonStep
                Layout.preferredWidth: 100
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.family: fontRoboto.name
                enabled: addressTextInput.currentLine < addressTextInput.lineCount && addressTextInput.text
                text: qsTr("STEP")
                onPressed: {
                    var line = addressTextInput.getCurrentLine();
                    var re = /0x[0-9A-Fa-f]{8}/g;
                    if (!re.test(line)) {
                        popupInputError.open()
                        return;
                    }
                    cache.request(parseInt(line));
                    addressTextInput.currentLine += 1;
                }
            }
        }

        Separator {
            id: inputSeparator
            width: parent.width
            height: 20
            anchors {
                top: rowRunButtons.bottom
            }
        }

        AddressTextInput {
            id: addressTextInput
            width: parent.width
            anchors {
                top: inputSeparator.bottom
                bottom: parent.bottom
            }
            font.family: fontRobotoMono.name
        }
    }

    RoundPane {
        id: paneCache
        anchors {
            top: paneConfig.top
            left: paneInputs.right
            leftMargin: window.margins
            right: parent.right
            rightMargin: window.margins
            bottom: paneInputs.bottom
        }
        CacheGrid {
            id: cacheGrid
            numSets: cache.numSets
            numWays: cache.numWays
            blockSize: cache.blockSize
            anchors {
                fill: parent
                margins: 20
            }
            fontFields: fontRobotoMono.name
            Component.onCompleted: {
                createGrid()
            }
        }
    }
}
