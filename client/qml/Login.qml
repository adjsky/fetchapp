import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: loginWindow
    flags: Qt.Window | Qt.CustomizeWindowHint
    visible: true
    width: 800
    height: 600
    signal logined

    Rectangle {
        id: background
        color: "#33383c"
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

        Image {
            id: closeButton
            source: "qrc:/images/close1.svg"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.topMargin: 5
            scale: closeButtonArea.containsMouse ? 1.2 : 1

            MouseArea {
                id: closeButtonArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    loginWindow.close()
                }
            }

            Behavior on scale {
                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
            }
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
        loginForm.registerButtonPressed.connect(function() {
            let signupForm = forms.push("forms/Signup.qml", StackView.Immediate)
            signupForm.tested.connect(function() {
                forms.pop(StackView.Immediate)
            })
        })
    }

    //        DropShadow {
    //            anchors.fill: header
    //            radius: 5
    //            verticalOffset: 5
    //            source: header
    //        }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
