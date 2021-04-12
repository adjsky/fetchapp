import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import UserManager 1.0
import "scripts/constants.js" as Constants
import "scripts/scripts.js" as Scripts
import "components"

ApplicationWindow {
    id: authWindow

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
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code !== 200) {
                                                    forms.item.errorMessage = Scripts.capitalize(response.message)
                                                } else {
                                                    handleAuth(response)
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
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code !== 200) {
                                                    forms.item.errorMessage = Scripts.capitalize(response.message)
                                                } else {
                                                    handleAuth(response)
                                                }
                                            } else {
                                                forms.item.errorMessage = error
                                            }
                                        })
            netManager.makeRequest("POST",
                                   JSON.stringify({ "email": email, "password": password }))
        }

        function handleAuth(response) {
            UserManager.saveToken(response.token, rememberToken)
            authWindow.success()
        }

        function restoreRequest(email) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/restore")
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                handleRestoreResponse(response, email)
                                            } else {
                                                forms.item.errorMessage = error
                                            }
                                        })
            netManager.makeRequest("PUT",
                                   JSON.stringify({ "email": email }))
        }

        function handleRestoreResponse(response, email) {
            if (response.code === 202) {
                showCodeForm(email)
            } else {
                forms.item.errorMessage = Scripts.capitalize(response.message)
            }
        }

        function restoreWithCodeRequest(code, oldPass, newPass) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/restore")
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code === 200) {
                                                    showLoginForm()
                                                } else {
                                                    console.log(response.message)
                                                }
                                            } else {
                                                console.log(error)
                                            }
                                        })
            netManager.makeRequest("PUT",
                                   JSON.stringify({ "code": code, "old_password": oldPass, "new_password": newPass }))
        }

        function validRequest(token) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/valid")
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                handleValidResponse(response)
                                            }
                                        })
            netManager.makeRequest("POST", JSON.stringify({"token": token}))
        }

        function handleValidResponse(response) {
            if (response.valid) {
                authWindow.success()
            } else {
                busyIndicator.running = false
                showLoginForm()
            }
        }

        function restoreValidRequest(email, code) {
            let netManager = new NetworkManager(Constants.serverPath + "/auth/restore/valid")
            netManager.finished.connect((data, error) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                handleRestoreValidResponse(response, code)
                                            } else {
                                                forms.item.errorMessage = error
                                            }
                                        })
            netManager.makeRequest("POST", JSON.stringify({"email": email, "code": code}))
        }

        function handleRestoreValidResponse(response, code) {
            if (response.code === 200) {
                if (response.valid) {
                    showChangePasswordForm(code)
                } else {
                    forms.item.errorMessage = "Invalid code"
                }
            } else {
                forms.item.errorMessage = Scripts.capitalize(response.message)
            }
        }

        function showLoginForm() {
            forms.source = "forms/Login.qml"
            forms.item.loginButtonClicked.connect((email, password, remember) => {
                                                     rememberToken = remember
                                                     loginRequest(email, password)
                                                 })
            forms.item.signUpButtonClicked.connect(() => {
                                                       showSignUpForm()
                                                   })
            forms.item.restoreButtonClicked.connect((email) => {
                                                        showRestoreForm()
                                                    })
        }

        function showSignUpForm() {
            forms.source = "forms/SignUp.qml"
            forms.item.signUpButtonClicked.connect((email, password) => {
                                                       signUpRequest(email, password)
                                                   })
            forms.item.returned.connect(() => {
                                            showLoginForm()
                                        })
        }

        function showCodeForm(email) {
            forms.source = "forms/Code.qml"
            forms.item.restoreEmail = email
            forms.item.backButtonClicked.connect(() => {
                                                     showRestoreForm()
                                                 })
            forms.item.nextButtonClicked.connect((code) => {
                                                     restoreValidRequest(email, code)
                                                 })
        }

        function showRestoreForm() {
            forms.source = "forms/Restore.qml"
            forms.item.nextButtonClicked.connect((email) => {
                                                     restoreRequest(email)
                                                 })
            forms.item.backButtonClicked.connect(() => {
                                                     showLoginForm()
                                                 })
        }

        function showChangePasswordForm(code) {
            forms.source = "forms/ChangePassword.qml"
            forms.item.changePassword.connect((oldPass, newPass) => {
                                                  restoreWithCodeRequest(code, oldPass, newPass)
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
                if (authWindow.visibility === ApplicationWindow.Maximized)
                    authWindow.visibility = ApplicationWindow.AutomaticVisibility
                else
                    authWindow.visibility = ApplicationWindow.Maximized
            }
        }

        DragHandler {
            target: null

            onActiveChanged: {
                if (active) {
                    authWindow.startSystemMove()
                }
            }
        }
    }

    CloseButton {
        anchors.right: parent.right
        onPressed: {
            authWindow.exit()
        }
    }

    Loader {
        id: forms
        anchors.centerIn: parent
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
