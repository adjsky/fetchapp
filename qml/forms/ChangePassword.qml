import QtQuick 2.15
import QtQuick.Controls 2.15
import "colors.js" as Colors
import "../components"

Rectangle {
    id: changePasswordForm

    property string oldPassErrorMessage: ""
    property string newPassErrorMessage: ""

    signal changePassword(string oldPass, string newPass)

    implicitHeight: 260
    implicitWidth: 360
    color: Colors.background
    radius: 10

    QtObject {
        id: internal

        function change() {
            let oldPass = oldPassField.text
            let newPass = newPassField.text
            let valid = true
            if (oldPass === "") {
                oldPassErrorMessage = "Provide old password"
                valid = false
            } else {
                oldPassErrorMessage = ""
            }

            if (newPass === "") {
                newPassErrorMessage = "Provide new password"
                valid = false
            } else {
                newPassErrorMessage = ""
            }

            if (valid) {
                changePasswordForm.changePassword(oldPass, newPass)
            }
        }
    }

    Item {
        id: form
        anchors.fill: parent
        anchors.margins: 20

        Label {
            id: chagePasswordLabel
            text: qsTr("Change password")
            color: Colors.excelFont
            font.family: "Roboto"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: 7

            Item {
                width: parent.width
                height: oldPassField.height + oldPassField.anchors.topMargin

                Label {
                    text: {
                        if (oldPassErrorMessage === "") {
                            qsTr("Old password")
                        } else {
                            qsTranslate("backend", oldPassErrorMessage)
                        }
                    }
                    font.pointSize: 8
                    color: oldPassErrorMessage === "" ? Colors.font : Colors.error
                    font.family: "Roboto"
                }

                UserInput {
                    id: oldPassField
                    width: parent.width
                    anchors.top: parent.top
                    anchors.topMargin: 18
                    height: 35
                    font.family: "Roboto"
                    font.pointSize: 10
                    borderColor: oldPassErrorMessage !== "" ? Colors.error : Colors.fieldBackground
                    borderFocusColor: oldPassErrorMessage !== "" ? Colors.error : Colors.background
                    echoMode: TextInput.Password
                }
            }

            Item {
                width: parent.width
                height: newPassField.height + newPassField.anchors.topMargin

                Label {
                    text: {
                        if (newPassErrorMessage === "") {
                            qsTr("New password")
                        } else {
                            qsTranslate("backend", newPassErrorMessage)
                        }
                    }
                    font.pointSize: 8
                    color: newPassErrorMessage === "" ? Colors.font : Colors.error
                    font.family: "Roboto"
                }

                UserInput {
                    id: newPassField
                    width: parent.width
                    height: 35
                    anchors.top: parent.top
                    anchors.topMargin: 18
                    font.family: "Roboto"
                    font.pointSize: 10
                    borderColor: newPassErrorMessage !== "" ? Colors.error : Colors.fieldBackground
                    borderFocusColor: newPassErrorMessage !== "" ? Colors.error : Colors.background
                    echoMode: TextInput.Password
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 5

            CustomButton {
                height: 35
                text: qsTr("Change")
                fontColor: Colors.font
                fontHoverColor: Colors.excelFont
                backgroundColor: "transparent"
                backgroundHoverColor: Colors.font
                borderColor: Colors.font
                borderHoverColor: borderColor

                onClicked: internal.change()
            }
        }
    }
}
