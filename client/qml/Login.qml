import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import UserManager 1.0
import "components"
import "scripts/constants.js" as Constants

ApplicationWindow {
    id: loginWindow

    property color backgroundColor: "#33383c"

    signal exit
    signal success

    flags: Qt.Window | Qt.FramelessWindowHint
    visible: true
    width: 800
    height: 600

    QtObject {
        id: internal

        function loginRequest(email, password) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/login");
            netManager.finished.connect((error, data) => {
                if (error === "") {
                    let response = JSON.parse(data)
                    if (response.code !== 200) {
                        forms.currentItem.errorMessage = qsTr(response.message)
                    } else {
                        console.log(data)
                    }
                } else {
                    forms.currentItem.errorMessage = qsTr(error)
                }
            })
            netManager.makeRequest("POST",
                                   JSON.stringify({ "email": email, "password": password }))
        }

        function signUpRequest(email, password) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/signup");
            netManager.finished.connect((error, data) => {
                if (error === "") {
                    let response = JSON.parse(data)
                    if (response.code !== 200) {
                        forms.currentItem.errorMessage = qsTr(response.message)
                    } else {
                        console.log(data)
                    }
                } else {
                    forms.currentItem.errorMessage = qsTr(error)
                }
            })
            netManager.makeRequest("POST",
                                   JSON.stringify({ "email": email, "password": password }))
        }

    }

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
            loginWindow.exit()
        }
    }

    StackView {
        id: forms
        anchors.centerIn: parent
        width: 360
        height: 360
    }

//    BusyIndicator {
//        id: control

//        contentItem: Item {
//            implicitWidth: 64
//            implicitHeight: 64

//            Item {
//                id: item
//                x: parent.width / 2 - 32
//                y: parent.height / 2 - 32
//                width: 64
//                height: 64
//                opacity: control.running ? 1 : 0

//                Behavior on opacity {
//                    OpacityAnimator {
//                        duration: 250
//                    }
//                }

//                RotationAnimator {
//                    target: item
//                    running: control.visible && control.running
//                    from: 0
//                    to: 360
//                    loops: Animation.Infinite
//                    duration: 1250
//                }

//                Repeater {
//                    id: repeater
//                    model: 6

//                    Rectangle {
//                        x: item.width / 2 - width / 2
//                        y: item.height / 2 - height / 2
//                        implicitWidth: 10
//                        implicitHeight: 10
//                        radius: 5
//                        color: "#21be2b"
//                        transform: [
//                            Translate {
//                                y: -Math.min(item.width, item.height) * 0.5 + 5
//                            },
//                            Rotation {
//                                angle: index / repeater.count * 360
//                                origin.x: 5
//                                origin.y: 5
//                            }
//                        ]
//                    }
//                }
//            }
//        }
//    }

    Component.onCompleted: {
        let loginForm = forms.push("forms/Login.qml", StackView.Immediate)
        loginForm.loginButtonPressed.connect((email, password, remember) => {
                                                internal.loginRequest(email, password)
                                             })
        loginForm.signUpButtonPressed.connect(() => {
            let signupForm = forms.push("forms/SignUp.qml", StackView.Immediate)
            signupForm.signUpButtonPressed.connect((email, password) => {
                internal.signUpRequest(email, password)
            })
            signupForm.returned.connect(() => forms.pop(StackView.Immediate))
        })
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
