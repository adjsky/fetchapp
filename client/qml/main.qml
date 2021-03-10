import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    flags: Qt.Window | Qt.FramelessWindowHint

    id: appWindow
    width: 1280
    height: 720
    visible: false

    MouseArea {
        id: moveWindow
        anchors.fill: parent
        property point lastClickPos

        onPressed: {
            lastClickPos = Qt.point(mouse.x, mouse.y)
        }

        DragHandler {
            target: null
            onActiveChanged: if (active) { appWindow.startSystemMove() }
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
        let loginWindow = loginComponent.createObject(appWindow)
        loginWindow.tokenReceived.connect(function() {
            loginWindow.destroy()
            appWindow.show()
        })
        loginWindow.exitPressed.connect(function() {
            loginWindow.destroy()
            appWindow.visible = true
            appWindow.close()
        })
        loginWindow.show()
    }
}
