import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick 2.15
import "colors.js" as Colors
import "../scripts/scripts.js" as Scripts
import "../components"

Rectangle {
    id: loginForm

    property string errorMessage: ""
    property color fieldBorderColor: errorMessage !== "" ? Colors.error : Colors.fieldBackground
    property color fieldBorderFocusColor: errorMessage !== "" ? Colors.error : Colors.background

    signal loginButtonClicked(string email, string password, bool remember)
    signal signUpButtonClicked

    radius: 10
    implicitHeight: 360
    implicitWidth: 360
    color: Colors.background

    QtObject {
        id: internal

        function login() {
            let email = emailField.text
            let password = passwordField.text
            if (email === "" || password === "") {
                loginForm.errorMessage = "Provide email and password"
            } else {
                let validEmail = Scripts.validateEmail(email)
                if (!validEmail) {
                    loginForm.errorMessage = "Invalid email address"
                }
                else {
                    loginForm.loginButtonClicked(email, password, rememberBox.checked)
                }
            }
        }
    }

    Item {
        id: form
        anchors.fill: parent
        anchors.bottomMargin: 40
        anchors.rightMargin: 25
        anchors.leftMargin: 25
        anchors.topMargin: 40

        Label {
            id: loginLabel
            color: Colors.excelFont
            text: qsTr("Please login")
            font.family: "Roboto"
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
        }

        Item {
            id: inputs
            height: 123
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 30

            Label {
                id: errorLabel
                text: qsTranslate("backend", loginForm.errorMessage)
                font.pointSize: 8
                color: Colors.error
                font.family: "Roboto"
                visible: loginForm.errorMessage !== ""
            }

            Item {
                id: fields
                anchors.top: parent.top
                anchors.topMargin: 15
                width: parent.width
                height: 77

                Column {
                    width: parent.width
                    height: parent.height
                    spacing: 7

                    UserInput {
                        id: emailField
                        width: parent.width
                        height: 35
                        font.family: "Roboto"
                        placeholderText: qsTr("Email address")
                        font.pointSize: 10
                        borderColor: fieldBorderColor
                        borderFocusColor: fieldBorderFocusColor
                    }

                    UserInput {
                        id: passwordField
                        width: parent.width
                        height: 35
                        font.family: "Roboto"
                        placeholderText: qsTr("Password")
                        font.pointSize: 10
                        echoMode: TextInput.Password
                        borderColor: fieldBorderColor
                        borderFocusColor: fieldBorderFocusColor
                    }
                }
            }

            Item {
                id: userControls
                width: parent.width
                height: 18
                anchors.bottom: parent.bottom

                CheckBox {
                    id: rememberBox
                    text: qsTr("Remember me")
                    font.pointSize: 10
                    spacing: 0
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    font.family: "Roboto"

                    indicator: Rectangle {
                        width: userControls.height
                        height: userControls.height
                        color: "transparent"
                        border.color: Colors.font
                        border.width: 1

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: Colors.excelFont
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
                        font: rememberBox.font
                        verticalAlignment: Qt.AlignVCenter
                        color: Colors.font
                        leftPadding: rememberBox.indicator.width + rememberBox.spacing
                    }
                }
            }
        }

        Item {
            id: buttons
            height: 100
            width: parent.width
            anchors.bottom: parent.bottom

            Column {
                spacing: 10
                width: parent.width
                height: parent.height

                Button {
                    id: loginButton
                    width: parent.width
                    height: 45
                    fontColor: Colors.excelFont
                    fontHoverColor: Colors.excelFont

                    onClicked: internal.login()

                    contentItem: Text {
                        text: qsTr("LOGIN")
                        font.pointSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Roboto"
                        color: excelFontColor

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
                            GradientStop { position: 0.0; color: gradientStart }
                            GradientStop { position: 1.0; color: gradientStop}
                            GradientStop { position: 0.0; color: Colors.gradientStart }
                            GradientStop { position: 1.0; color: Colors.gradientStop }
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
                    width: parent.width
                    height: 45
                    fontColor: Colors.font
                    fontHoverColor: Colors.excelFont

                    onClicked: {
                        loginForm.errorMessage = ""
                        loginForm.signUpButtonClicked()
                    }

                    contentItem: Text {
                        text: qsTr("SIGN UP")
                        font.pointSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Roboto"
                        color: registerButton.hovered ? excelFontColor : fontColor
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
                        color: registerButton.hovered ? fontColor : "transparent"
                        border.color: fontColor
                        radius: 5
                        scale: registerButton.down ? 0.95 : 1
                        color: registerButton.hovered ? Colors.font : "transparent"
                        border.color: Colors.font

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

    Shortcut {
        sequence: "return"
        onActivated: {
            internal.login()
        }
    }
}
