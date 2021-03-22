import QtQuick 2.0

Item {
    id: sidebarItem

    required property url iconPath
    required property int iconWidth
    required property int iconHeight
    property color backgroundColor: "#41484b"
    property color hoverBackgroundColor: "#3a3e41"
    property color activeColor: "#3a3e41"
    property color leftBorderColor: "#76e6db"
    property bool active: false

    signal clicked
    signal pressed

    implicitWidth: 40
    implicitHeight: 40

    Rectangle {
        id: background
        color: if (sidebarItem.active) {
                   activeColor
               } else if (mouseArea.containsMouse) {
                   hoverBackgroundColor
               } else {
                   backgroundColor
               }

        anchors.fill: parent

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                sidebarItem.clicked()
            }

            onPressed: {
                sidebarItem.pressed()
            }
        }
    }

    Image {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: iconWidth
        height: iconHeight
        source: iconPath
    }

    Rectangle {
        id: activeLeft
        width: 3
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: leftBorderColor
        opacity: sidebarItem.active ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}
}
##^##*/
