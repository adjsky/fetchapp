import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.NetworkManager 1.0

ApplicationWindow {
    id: loginWindow
    flags: Qt.Window | Qt.CustomizeWindowHint
    visible: true
    width: 800
    height: 600
    signal logined

    Rectangle {
        id: background
        color: "#33383c"
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

        Image {
            id: closeButton
            source: "qrc:/images/close1.svg"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 5
            anchors.topMargin: 5
            scale: closeButtonArea.containsMouse ? 1.2 : 1

            MouseArea {
                id: closeButtonArea
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    loginWindow.close()
                }
            }

            Behavior on scale {
                NumberAnimation { duration: 100; easing.type: Easing.InOutCubic }
            }
        }

        Rectangle {
            id: rectangle
            width: 360
            height: 360
            color: "#44494d"
            radius: 10
            border.color: "#44494d"
            anchors.centerIn: parent

            ColumnLayout {
                anchors.fill: parent

                Label {
                    color: "#ffffff"
                    text: qsTr("Please login")
                    font.pointSize: 16
                    font.family: "Tahoma"
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
                        height: 115
                        anchors.fill: parent

                        TextField {
                            id: emailField
                            font.family: "Tahoma"
                            placeholderTextColor: "#989b9c"
                            color: "#989b9c"
                            Layout.minimumHeight: 35
                            leftPadding: 15
                            Layout.preferredHeight: 35
                            Layout.rightMargin: 25
                            Layout.leftMargin: 25
                            Layout.fillWidth: true
                            placeholderText: qsTr("Email address")
                            selectByMouse: true

                            background: Rectangle {
                                color: "#33383c"
                                radius: 4
                                border {
                                    color: passwordField.focus ? "#44494d" : "#33383c"
                                    width: 1

                                    Behavior on color {
                                        ColorAnimation {
                                            duration: 50
                                        }
                                    }
                                }
                            }
                        }

                        TextField {
                            id: passwordField
                            font.family: "Tahoma"
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
                                color: "#33383c"
                                radius: 4
                                border {
                                    color: passwordField.focus ? "#44494d" : "#33383c"
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
                                font.family: "Tahoma"
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
                                let xhr = new XMLHttpRequest()

                                xhr.open("POST", "http://localhost:8080/login")

                                xhr.onload = function() {
                                    console.log(xhr.response)
                                }

                                xhr.onerror = function() {
                                    console.log("error")
                                }

                                var request = {
                                    "email": emailField.text,
                                    "password:": passwordField.text
                                }


                                xhr.send(JSON.stringify(request))
                            }

                            contentItem: Text {
                                text: "LOGIN"
                                font.family: "Tahoma"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.bold: false
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

                            contentItem: Text {
                                text: qsTr("REGISTER")
                                font.family: "Tahoma"
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
    }

    //        DropShadow {
    //            anchors.fill: header
    //            radius: 5
    //            verticalOffset: 5
    //            source: header
    //        }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
