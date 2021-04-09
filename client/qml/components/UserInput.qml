import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: userInput

    property color backgroundColor: "#33383c"
    property color borderColor: "#33383c"
    property color borderFocusColor: "#44494d"
    property int borderWidth: 1
    property int borderRadius: 4

    implicitWidth: 100
    implicitHeight: 35
    selectByMouse: true
    leftPadding: 15
    placeholderText: qsTr("")
    placeholderTextColor: "#989b9c"
    color: "#989b9c"
    selectionColor: "#ffffff"

    QtObject {
        id: internal

        property color dynamicColor: if (userInput.activeFocus) {
                                        userInput.borderFocusColor
                                     } else {
                                        userInput.borderColor
                                     }
    }

    background: Rectangle {
        color: backgroundColor
        radius: borderRadius
        border {
            color: internal.dynamicColor
            width: borderWidth

            Behavior on color {
                ColorAnimation {
                    duration: 50
                }
            }
        }
    }
}
