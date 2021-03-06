import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../scripts/scripts.js" as Scripts
import "colors.js" as Colors
import "../components"

Rectangle {
    id: signUpForm

    property string errorMessage: ""
    property color fieldBorderColor: errorMessage !== "" ? Colors.error : Colors.fieldBackground
    property color fieldBorderFocusColor: errorMessage !== "" ? Colors.error : Colors.background

    signal signUpButtonClicked(string email, string password)
    signal returned

    color: Colors.background
    radius: 10
    implicitWidth: 360
    implicitHeight: 360

    QtObject {
        id: internal

        function signUp() {
            let email = emailField.text
            let password = passwordField.text
            if (email === "" || password === "") {
                signUpForm.errorMessage = "Provide email and password"
            } else {
                let validEmail = Scripts.validateEmail(email)
                if (!validEmail) {
                    signUpForm.errorMessage = "Invalid email address"
                }
                else {
                    errorMessage = ""
                    signUpForm.signUpButtonClicked(email, password)
                }
            }
        }
    }

    Item {
        id: form
        anchors.fill: parent
        anchors.bottomMargin: 40
        anchors.topMargin: 40
        anchors.rightMargin: 25
        anchors.leftMargin: 25


        Label {
            id: loginLabel
            color: Colors.excelFont
            text: qsTr("Sign up")
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
                text: qsTranslate("backend", signUpForm.errorMessage)
                font.pointSize: 8
                color: Colors.error
                visible: signUpForm.errorMessage !== ""
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

            Label {
                id: returnButton
                color: Colors.font
                text: qsTr("Already have an account")
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.bottom: parent.bottom
                font.family: "Roboto"
                font.pointSize: 10

                background: Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
                    opacity: accountButtonArea.containsMouse ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.InOutCubic
                        }
                    }
                }

                MouseArea {
                    id: accountButtonArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: returned()
                }
            }
        }

        CustomButton {
            id: signUpButton
            width: parent.width
            height: 45
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 27
            fontHoverColor: Colors.excelFont
            fontColor: Colors.excelFont
            text: qsTr("SIGN UP")

            onClicked: internal.signUp()

            background: Rectangle {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Colors.gradientStart }
                    GradientStop { position: 1.0; color: Colors.gradientStop }
                    orientation: Gradient.Horizontal
                }
                scale: signUpButton.down ? signUpButton.scaleSize : 1
                radius: signUpButton.radius

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "return"
        onActivated: {
            internal.signUp()
        }
    }
}
