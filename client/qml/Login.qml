import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import TokenManager 1.0
import "components"

ApplicationWindow {
    id: loginWindow

    property color backgroundColor: "#33383c"

    signal exitPressed
    signal tokenReceived

    flags: Qt.Window | Qt.FramelessWindowHint
    visible: true
    width: 800
    height: 600

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent

            onDoubleClicked: {
                if (loginWindow.visibility === ApplicationWindow.Maximized)
                    loginWindow.visibility = ApplicationWindow.AutomaticVisibility
                else
                    loginWindow.visibility = ApplicationWindow.Maximized
            }
        }

        DragHandler {
            target: null

            onActiveChanged: {
                if (active) {
                    loginWindow.startSystemMove()
                }
            }
        }
    }

    CloseButton {
        anchors.right: parent.right
        onPressed: {
            loginWindow.exitPressed()
        }
    }

    StackView {
        id: forms
        anchors.centerIn: parent
        width: 360
        height: 360
    }

    Component.onCompleted: {
        let loginForm = forms.push("forms/Login.qml", StackView.Immediate)
        loginForm.logined.connect(function(token, remember) {
            TokenManager.saveToken(token, remember)
            tokenReceived()
        })
        loginForm.registerButtonPressed.connect(function() {
            let signupForm = forms.push("forms/Signup.qml", StackView.Immediate)
            signupForm.registered.connect(function(token) {
                TokenManager.saveToken(token, true)
                tokenReceived()
            })
            signupForm.returned.connect(function() { forms.pop(StackView.Immediate) })
        })
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
