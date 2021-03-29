import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../scripts/scripts.js" as Scripts
import "../scripts/constants.js" as Constants
import "../components"

Rectangle {
    id: signupForm

    property color backgroundColor: "#44494d"
    property color errorColor: "red"
    property color excelFontColor: "#ffffff"
    property color fontColor: "#989b9c"
    property color gradientStart: "#e03614"
    property color gradientStop: "#de0172"
    property color fieldBackgroundColor: "#33383c"
    property color fieldBorderColor: internal.error ? errorColor : fieldBackgroundColor
    property color fieldBorderFocusColor: internal.error ? errorColor : backgroundColor

    signal registered(string token)
    signal returned

    color: backgroundColor
    radius: 10
    implicitHeight: 360
    implicitWidth: 360

    // Internal
    QtObject {
        id: internal
        property bool error: false

        function loginRequest() {
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

                    let netManager = new NetworkManager(Constants.serverPath + "/auth/signup");
                    netManager.makeRequest("POST", JSON.stringify({ "email": email, "password": password }))
                    netManager.finished.connect((error, data) => {
                        if (error === "") {
                            let response = JSON.parse(data)
                            if (response.code !== 200) {
                                internal.error = true
                                errorMessage.text = response.message
                            } else {
                                registered(response.token)
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
                id: errorMessage
                font.pointSize: 8
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
                color: fontColor
                text: "Already have an account"
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

        Button {
            id: signupButton
            text: qsTr("Register")
            width: parent.width
            height: 45
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 27

            onPressed: internal.loginRequest()

            contentItem: Text {
                text: "REGISTER"
                font.pointSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Roboto"
                color: excelFontColor

                scale: signupButton.down ? 0.95 : 1

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
                    GradientStop { position: 1.0; color: gradientStop }
                    orientation: Gradient.Horizontal
                }
                scale: signupButton.down ? 0.95 : 1
                radius: 5

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }
    }
}
