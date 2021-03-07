import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import "qrc:/scripts/scripts.js" as Scripts

Rectangle {
    id: signupForm
    color: "#44494d"
    radius: 10
    border.color: "#44494d"
    implicitHeight: 360
    implicitWidth: 360

    signal registered(string token)
    signal returned
    property bool error

    MouseArea {
        anchors.fill: parent

        onClicked: {
            emailField.focus = false;
            passwordField.focus = false;
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Label {
            color: "#ffffff"
            text: "Sign up"
            font.pointSize: 16
            Layout.topMargin: 35
            font.family: "Roboto"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        }

        Item {
            Layout.bottomMargin: 25
            Layout.minimumHeight: 125
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: 125
            Layout.fillWidth: true
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
                                color: signupForm.error ? "red" : passwordField.focus ? "#44494d" : "#33383c"
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
                        visible: signupForm.error
                    }
                }

                TextField {
                    id: passwordField
                    color: "#989b9c"
                    Layout.rightMargin: 25
                    Layout.fillWidth: true
                    Layout.leftMargin: 25
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    echoMode: TextInput.Password
                    placeholderText: qsTr("Password")
                    placeholderTextColor: "#989b9c"
                    leftPadding: 15
                    background: Rectangle {
                        id: passwordFieldBackground
                        color: "#33383c"
                        radius: 4
                        border.color: signupForm.error ? "red" : passwordField.focus ? "#44494d" : "#33383c"
                        border.width: 1
                    }
                    font.family: "Roboto"
                    selectByMouse: true
                    Layout.minimumHeight: 35
                    Layout.preferredHeight: 35
                }

                Item {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.rightMargin: 25
                    Layout.leftMargin: 25
                    Layout.minimumHeight: 18
                    Layout.preferredHeight: 18
                    Layout.fillWidth: true

                    Label {
                        color: "#989b9c"
                        text: "Already have an account"
                        anchors.left: parent.left
                        anchors.leftMargin: 5
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

                            onClicked: {
                                returned()
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: signupButton
            text: qsTr("Register")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.bottomMargin: 50
            Layout.minimumHeight: 45
            Layout.preferredHeight: 45
            font.family: "Roboto"
            Layout.rightMargin: 25
            Layout.leftMargin: 25
            Layout.fillWidth: true

            onPressed: {
                let email = emailField.text
                let password = passwordField.text
                if (email === "" || password === "") {
                    signupForm.error = true
                    errorMessage.text = "Provide email and password"
                } else {
                    email = Scripts.validateEmail(email)
                    if (email === "") {
                        signupForm.error = true
                        errorMessage.text = "Invalid email address"
                    } else {
                        signupForm.error = false

                        let netManager = new NetworkManager("http://localhost:8080/signup");
                        netManager.makeRequest("POST", JSON.stringify({ "email": email, "password": password }))
                        netManager.finished.connect(function(error, data) {
                            if (error === "") {
                                let response = JSON.parse(data)
                                if (response.code !== 200) {
                                    signupForm.error = true
                                    errorMessage.text = response.message
                                } else {
                                    registered(response.token)
                                }
                            } else {
                                signupForm.error = true
                                errorMessage.text = error
                            }
                        })
                    }
                }
            }

            contentItem: Text {
                text: "REGISTER"
                font.family: "Roboto"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"

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
                    GradientStop { position: 0.0; color: "#e03614" }
                    GradientStop { position: 1.0; color: "#de0172" }
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
