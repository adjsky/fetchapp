import QtQuick 2.15

Item {
    id: closeButton

    property int iconWidth: 24
    property int iconHeight: 24
    property url iconPath: "../images/close1.svg"

    signal pressed

    implicitWidth: 30
    implicitHeight: 30

    Image {
        id: closeButtonIcon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: iconWidth
        height: iconHeight
        source: iconPath
        scale: closeButtonArea.containsMouse ? 1.2 : 1

        Behavior on scale {
            NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
        }
    }

    MouseArea {
        id: closeButtonArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            closeButton.pressed()
        }
    }
}
