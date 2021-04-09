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
                        forms.item.errorMessage = Scripts.capitalize(response.message)
                    } else {
                        handleAuthResponse(response)
                    }
                } else {
                    forms.item.errorMessage = error
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
                        forms.item.errorMessage = Scripts.capitalize(response.message)
                    } else {
                        handleAuthResponse(response)
                    }
                } else {
                    forms.item.errorMessage = error
                }
            })
            netManager.makeRequest("POST",
                                   JSON.stringify({ "email": email, "password": password }))
        }

        function handleAuthResponse(response) {
            forms.item.errorMessage = ""
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
                busyIndicator.running = false
                showLoginForm()
            }
        }

        function showLoginForm() {
            forms.source = "forms/Login.qml"
            forms.item.loginButtonClicked.connect((email, password, remember) => {
                                                    rememberToken = remember
                                                    internal.loginRequest(email, password)
                                                 })
            forms.item.signUpButtonClicked.connect(() => {
                showSignUpForm()
            })
        }

        function showSignUpForm() {
            forms.source = "forms/SignUp.qml"
            forms.item.signUpButtonClicked.connect((email, password) => {
                internal.signUpRequest(email, password)
            })
            forms.item.returned.connect(() => {
                                            showLoginForm()
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

    Loader {
        id: forms
        anchors.centerIn: parent
        width: 360
        height: 360
    }

    CustomBusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        indicatorColor: "#ffffff"
        running: true
    }

    Component.onCompleted: {
        let token = UserManager.getToken()
        if (token === "") {
            busyIndicator.running = false
            internal.showLoginForm()
        } else {
            internal.validRequest(token)
        }
    }
}
