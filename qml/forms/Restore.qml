import QtQuick 2.15
import QtQuick.Controls 2.15
import "colors.js" as Colors
import "../scripts/scripts.js" as Scripts
import "../components"

Rectangle {
    id: restoreForm

    property string errorMessage: ""
    property color fieldBorderColor: errorMessage !== "" ? Colors.error : Colors.fieldBackground
    property color fieldBorderFocusColor: errorMessage !== "" ? Colors.error : Colors.background

    signal nextButtonClicked(string email)
    signal backButtonClicked

    implicitWidth: 360
    implicitHeight: 220
    color: Colors.background
    radius: 10

    QtObject {
        id: internal

        function next() {
            let email = emailField.text
            if (email === "") {
                restoreForm.errorMessage = "Provide email and password"
            } else {
                let validEmail = Scripts.validateEmail(email)
                if (!validEmail) {
                    restoreForm.errorMessage = "Invalid email address"
                }
                else {
                    errorMessage = ""
                    restoreForm.nextButtonClicked(email)
                }
            }
        }
    }

    Item {
        id: form
        anchors.fill: parent
        anchors.margins: 20

        Label {
            id: restoreLabel
            text: qsTr("Provide email")
            color: Colors.excelFont
            font.family: "Roboto"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            width: parent.width
            anchors.verticalCenterOffset: -5
            anchors.centerIn: parent
            spacing: 5

            Label {
                width: parent.width
                text: qsTr("Provide your account email")
                font.family: "Roboto"
                font.pointSize: 10
                color: Colors.font
                wrapMode: Text.Wrap
            }

            Column {
                width: parent.width
                spacing: 2

                Label {
                    id: errorLabel
                    text: qsTranslate("backend", restoreForm.errorMessage)
                    font.pointSize: 8
                    color: Colors.error
                    font.family: "Roboto"
                    visible: restoreForm.errorMessage !== ""
                }

                UserInput {
                    id: emailField
                    width: parent.width
                    height: 40
                    font.family: "Roboto"
                    placeholderText: qsTr("Email")
                    font.pointSize: 10
                    borderColor: fieldBorderColor
                    borderFocusColor: fieldBorderFocusColor
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 5

            CustomButton {
                width: 65
                height: 35
                text: qsTr("Back")
                fontHoverColor: "#cc535353"
                fontColor: "#535353"
                backgroundColor: "#ffffff"
                backgroundHoverColor: "#ccffffff"
                borderColor: backgroundColor
                borderHoverColor: backgroundHoverColor

                onClicked: backButtonClicked()
            }

            CustomButton {
                width: 65
                height: 35
                text: qsTr("Next")
                fontColor: Colors.font
                fontHoverColor: Colors.excelFont
                backgroundColor: "transparent"
                backgroundHoverColor: Colors.font
                borderColor: Colors.font
                borderHoverColor: borderColor

                onClicked: internal.next()
            }
        }
    }
}


