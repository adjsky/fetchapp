import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: customButton

    property int radius: 5
    property double scaleSize: 0.95
    property color fontColor: "gray"
    property color fontHoverColor: "white"
    property color borderColor: "gray"
    property color borderHoverColor: "white"
    property color backgroundColor: "white"
    property color backgroundHoverColor: "gray"

    implicitHeight: 45
    text: "Button"
    font.family: "Roboto"
    font.pointSize: 10

    contentItem: Text {
        text: customButton.text
        font: customButton.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: customButton.hovered ? fontHoverColor : fontColor
        scale: customButton.down ? scaleSize : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    background: Rectangle {
        color: customButton.hovered ? backgroundHoverColor : backgroundColor
        border.color: customButton.hovered ? borderHoverColor : borderColor
        radius: customButton.radius
        scale: customButton.down ? scaleSize : 1

        Behavior on scale {
            NumberAnimation {
                duration: 100
                easing.type: Easing.InOutCubic
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }
}
