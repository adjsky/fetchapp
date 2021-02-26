import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    property QtObject loginWindow
    flags: Qt.Window | Qt.CustomizeWindowHint

    id: appWindow
    width: 1280
    height: 720
    visible: false
    title: qsTr("Hello World")

    MouseArea {
        id: moveWindow
        anchors.fill: parent
        property point lastClickPos

        onPressed: {
            lastClickPos = Qt.point(mouse.x, mouse.y)
        }

        DragHandler {
            target: null
            onActiveChanged: if (active) { loginWindow.startSystemMove() }
        }
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        cursorShape: Qt.SizeHorCursor

        DragHandler {
            target: null
            onActiveChanged: if (active) { loginWindow.startSystemResize(Qt.RightEdge) }
        }
    }

    Component.onCompleted: {
        let loginComponent = Qt.createComponent("Login.qml")
        loginWindow = loginComponent.createObject(appWindow)
        loginWindow.show()

        loginWindow.logined.connect(function() {
            loginWindow.destroy()
            appWindow.show()
        })
    }
}
