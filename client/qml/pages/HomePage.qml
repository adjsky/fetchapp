import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: homePage

    property color backgroundColor: "#ffffff"

    implicitWidth: 1280
    implicitHeight: 720
    color: backgroundColor

    Label {
        text: qsTr("Hi there!")
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 15
        font.family: "Roboto"
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
