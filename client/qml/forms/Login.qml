import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick 2.12
import "../scripts/scripts.js" as Scripts
import "../scripts/constants.js" as Constants
import "../components"

Rectangle {
    id: loginForm

    property color backgroundColor: "#44494d"
    property color errorColor: "red"
    property color excelFontColor: "#ffffff"
    property color fontColor: "#989b9c"
    property color gradientStart: "#e03614"
    property color gradientStop: "#de0172"
    property color fieldBackgroundColor: "#33383c"
    property color fieldBorderColor: internal.error ? errorColor : fieldBackgroundColor
    property color fieldBorderFocusColor: internal.error ? errorColor : backgroundColor

    signal logined(string token, bool remember)
    signal registerButtonPressed

    color: backgroundColor
    radius: 10
    implicitHeight: 360
    implicitWidth: 360

    // Internal
    QtObject {
        id: internal
        property bool error: false

        function signupRequest() {
            let email = emailField.text
            let password = passwordField.text
            if (email === "" || password === "") {
                internal.error = true
                errorMessage.text = "Provide email and password"
            } else {
                let validEmail = Scripts.validateEmail(email)
                if (!validEmail) {
                    internal.error = true
                    errorMessage.text = "Invalid email address"
                } else {
                    internal.error = false

                    let netManager = new NetworkManager(Constants.serverPath + "/auth/login");
                    netManager.makeRequest("GET", JSON.stringify({ "email": email, "password": password }))
                    netManager.finished.connect(function(error, data) {
                        if (error === "") {
                            let response = JSON.parse(data)
                            if (response.code !== 200) {
                                internal.error = true
                                errorMessage.text = response.message
                            } else {
                                logined(response.token, rememberBox.checked)
                            }
                        } else {
                            internal.error = true
                            errorMessage.text = error
                        }
                    })
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
            color: excelFontColor
            text: qsTr("Please login")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 16
            font.family: "Roboto"
        }

        Item {
            id: inputs
            height: 123
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 30

            Label {
                id: errorMessage
                font.pointSize: 8
                font.family: "Roboto"
                color: errorColor
                visible: internal.error
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
                        borderColor: fieldBorderColor
                        borderFocusColor: fieldBorderFocusColor
                    }

                    UserInput {
                        id: passwordField
                        width: parent.width
                        height: 35
                        font.family: "Roboto"
                        placeholderText: qsTr("Password")
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
                    text: "Remember me"
                    font.family: "Roboto"
                    font.pointSize: 10
                    spacing: 0
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom

                    indicator: Rectangle {
                        width: userControls.height
                        height: userControls.height
                        color: "transparent"
                        border.color: fontColor
                        border.width: 1

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: excelFontColor
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
                        color: fontColor
                        font: rememberBox.font
                        verticalAlignment: Qt.AlignVCenter
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

                    onPressed: internal.signupRequest()

                    contentItem: Text {
                        text: "LOGIN"
                        font.family: "Roboto"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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

                    onClicked: {
                        internal.error = false
                        registerButtonPressed()
                    }

                    contentItem: Text {
                        text: qsTr("SIGN UP")
                        font.family: "Roboto"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
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
