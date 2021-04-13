import QtQuick 2.15
import QtQuick.Controls 2.15
import "colors.js" as Colors
import "../components"

Rectangle {
    id: codeForm

    property string errorMessage: ""
    property string restoreEmail: ""
    property color fieldBorderColor: errorMessage !== "" ? Colors.error : Colors.fieldBackground
    property color fieldBorderFocusColor: errorMessage !== "" ? Colors.error : Colors.background

    signal nextButtonClicked(string code)
    signal backButtonClicked

    implicitWidth: 360
    implicitHeight: 220
    color: Colors.background
    radius: 10

    QtObject {
        id: internal

        function next() {
            let code = codeField.text
            if (code === "") {
                errorMessage = "Provide code"
            } else {
                if (code.length !== 8) {
                    errorMessage = "Invalid code"
                } else {
                    errorMessage = ""
                    codeForm.nextButtonClicked(code)
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
            text: qsTr("Provide code")
            color: Colors.excelFont
            font.family: "Roboto"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column {
            width: parent.width
            anchors.centerIn: parent
            spacing: 5

            Label {
                width: parent.width
                text: qsTr("Email with the code was sent to") + " " + restoreEmail
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
                    text: qsTranslate("backend", codeForm.errorMessage)
                    font.pointSize: 8
                    color: Colors.error
                    font.family: "Roboto"
                    visible: codeForm.errorMessage !== ""
                }

                UserInput {
                    id: codeField
                    width: parent.width
                    height: 40
                    font.family: "Roboto"
                    placeholderText: qsTr("Code")
                    font.pointSize: 10
                    borderColor: fieldBorderColor
                    borderFocusColor: fieldBorderFocusColor
                    maximumLength: 8
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

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}
}
##^##*/
