import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import UserManager 1.0
import "scripts/constants.js" as Constants
import "scripts/scripts.js" as Scripts
import "components"

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
        property bool rememberToken: true

        function loginRequest(email, password) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/login");
            netManager.finished.connect((error, data) => {
                if (error === "") {
                    let response = JSON.parse(data)
                    if (response.code !== 200) {
                        forms.currentItem.errorMessage = Scripts.capitalize(response.message)
                    } else {
                        handleAuthResponse(response)
                    }
                } else {
                    forms.currentItem.errorMessage = error
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
                        forms.currentItem.errorMessage = Scripts.capitalize(response.message)
                    } else {
                        handleAuthResponse(response)
                    }
                } else {
                    forms.currentItem.errorMessage = error
                }
            })
            netManager.makeRequest("POST",
                                   JSON.stringify({ "email": email, "password": password }))
        }

        function handleAuthResponse(response) {
            forms.currentItem.errorMessage = ""
            UserManager.saveToken(response.token, rememberToken)
            loginWindow.success()
        }

        function validRequest(token) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/valid")
            netManager.finished.connect((err, data) => {
                                            if (err === "") {
                                                let response = JSON.parse(data)
                                                handleValidResponse(response)
                                            }
                                        })
            netManager.makeRequest("POST", JSON.stringify({"token": token}))
        }

        function handleValidResponse(response) {
            if (response.valid) {
                loginWindow.success()
            } else {
                showForm()
            }
        }

        function showForm() {
            busyIndicator.running = false
            let loginForm = forms.push("forms/Login.qml", StackView.Immediate)
            loginForm.loginButtonPressed.connect((email, password, remember) => {
                                                    rememberToken = remember
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

    CustomBusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        indicatorColor: "#ffffff"
    }

    Component.onCompleted: {
        let token = UserManager.getToken()
        if (token === "") {
            internal.showForm()
        } else {
            internal.validRequest(token)
        }
    }
}


