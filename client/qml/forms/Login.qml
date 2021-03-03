import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12
import "qrc:/scripts/scripts.js" as Scripts

Rectangle {
    id: loginForm
    color: "#44494d"
    radius: 10
    border.color: "#44494d"
    implicitHeight: 360
    implicitWidth: 360

    signal registerButtonPressed
    property bool error

    ColumnLayout {
        anchors.fill: parent

        Label {
            color: "#ffffff"
            text: qsTr("Please login")
            font.pointSize: 16
            font.family: "Roboto"
            Layout.topMargin: 35
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        }

        Item {
            Layout.topMargin: 5
            Layout.minimumHeight: 125
            Layout.preferredHeight: 125
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            ColumnLayout {
                anchors.fill: parent

                Item {
                    Layout.preferredHeight: 35
                    Layout.rightMargin: 25
                    Layout.leftMargin: 25
                    Layout.fillWidth: true

                    TextField {
                        id: emailField
                        font.family: "Roboto"
                        placeholderTextColor: "#989b9c"
                        color: "#989b9c"
                        leftPadding: 15
                        placeholderText: qsTr("Email address")
                        selectByMouse: true
                        anchors.fill: parent

                        background: Rectangle {
                            id: emailFieldBackground
                            color: "#33383c"
                            radius: 4
                            border {
                                color: loginForm.error ? "red" : passwordField.focus ? "#44494d" : "#33383c"
                                width: 1

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 50
                                    }
                                }
                            }
                        }
                    }

                    Label {
                        id: errorMessage
                        y: parent.y - 22
                        font.pointSize: 8
                        font.family: "Roboto"
                        color: "red"
                        visible: loginForm.error
                    }
                }

                TextField {
                    id: passwordField
                    font.family: "Roboto"
                    placeholderTextColor: "#989b9c"
                    color: "#989b9c"
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.minimumHeight: 35
                    leftPadding: 15
                    Layout.preferredHeight: 35
                    Layout.rightMargin: 25
                    Layout.leftMargin: 25
                    Layout.fillWidth: true
                    placeholderText: qsTr("Password")
                    selectByMouse: true
                    echoMode: TextInput.Password



                    background: Rectangle {
                        id: passwordFieldBackground
                        color: "#33383c"
                        radius: 4
                        border {
                            color: loginForm.error ? "red" : passwordField.focus ? "#44494d" : "#33383c"
                            width: 1

                            Behavior on color {
                                ColorAnimation {
                                    duration: 50
                                }
                            }
                        }
                    }
                }

                Item {
                    id: userControls
                    Layout.topMargin: 0
                    Layout.rightMargin: 25
                    Layout.leftMargin: 25
                    Layout.minimumHeight: 18
                    Layout.preferredHeight: 18
                    Layout.fillWidth: true

                    CheckBox {
                        id: rememberBox
                        text: "Remember me"
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        font.family: "Roboto"
                        font.pointSize: 10
                        spacing: 0

                        indicator: Rectangle {
                            width: userControls.height
                            height: userControls.height
                            color: "transparent"
                            border.color: "#989b9c"
                            border.width: 1

                            Rectangle {
                                width: parent.width
                                height: parent.width
                                opacity: rememberBox.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 50
                                    }
                                }
                            }
                        }

                        contentItem: Text {
                            text: rememberBox.text
                            color: "#989b9c"
                            font: rememberBox.font
                            verticalAlignment: Qt.AlignVCenter
                            leftPadding: rememberBox.indicator.width + rememberBox.spacing
                        }
                    }
                }

            }
        }

        Item {
            height: 105
            Layout.bottomMargin: 20
            Layout.preferredHeight: 115
            Layout.fillWidth: true

            ColumnLayout {
                height: 100
                anchors.fill: parent

                Button {
                    id: loginButton
                    Layout.minimumHeight: 45
                    Layout.preferredHeight: 45
                    Layout.leftMargin: 25
                    Layout.rightMargin: 25
                    Layout.fillWidth: true

                    onPressed: {
                        let email = emailField.text
                        let password = passwordField.text
                        if (email === "" || password === "") {
                            loginForm.error = true
                            errorMessage.text = "Provide email and password"
                        } else {
                            email = Scripts.validateEmail(email)
                            if (email === "") {
                                loginForm.error = true
                                errorMessage.text = "Invalid email address"
                            } else {
                                loginForm.error = false

                                Scripts.makeLoginRequest(email, password, function(xhr) {
                                    if (xhr.status === 0) {
                                        loginForm.error = true
                                        errorMessage.text = "Something bad happened on the server"
                                    } else {
                                        let responseBody = xhr.response
                                        if (xhr.status !== 200) {
                                            loginForm.error = true
                                            errorMessage.text = responseBody.message
                                        }
                                        else {
                                            console.log(JSON.stringify(responseBody))
                                        }
                                    }
                                })
                            }
                        }
                    }

                    contentItem: Text {
                        text: "LOGIN"
                        font.family: "Roboto"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "#ffffff"

                        scale: loginButton.down ? 0.95 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }

                    background: Rectangle {
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#e03614" }
                            GradientStop { position: 1.0; color: "#de0172" }
                            orientation: Gradient.Horizontal
                        }
                        scale: loginButton.down ? 0.95 : 1
                        radius: 5

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutCubic
                            }
                        }
                    }
                }

                Button {
                    id: registerButton
                    Layout.minimumHeight: 45
                    Layout.preferredHeight: 45
                    Layout.rightMargin: 25
                    Layout.leftMargin: 25
                    Layout.fillWidth: true

                    onClicked: {
                        loginForm.error = false
                        registerButtonPressed()                 
                    }

                    contentItem: Text {
                        text: qsTr("SIGN UP")
                        font.family: "Roboto"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: registerButton.hovered ? "#ffffff" : "#989b9c"
                        scale: registerButton.down ? 0.95 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutCubic
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }

                    background: Rectangle {
                        color: registerButton.hovered ? "#989b9c" : "transparent"
                        border.color: "#989b9c"
                        radius: 5
                        scale: registerButton.down ? 0.95 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutCubic
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }
                    }
                }
            }
        }
    }
}
