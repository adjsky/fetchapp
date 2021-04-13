import QtQuick 2.15
import QtQuick.Controls 2.15
import Language 1.0
import Config 1.0

Rectangle {
    id: egePage

    property color backgroundColor: "#ffffff"

    signal signOut

    implicitWidth: 640
    implicitHeight: 720
    color: backgroundColor

    Item {
        id: pageContent
        anchors.fill: parent
        anchors.margins: 20

        Column {
            anchors.fill: parent
            spacing: 5

            Row {
                width: parent.width
                height: 30

                Label {
                    width: 150
                    height: 30
                    text: qsTr("Language") + ":"
                    verticalAlignment: Text.AlignVCenter
                }

                ComboBox {
                    id: languageComboBox
                    width: 150
                    height: parent.height
                    model: ListModel {
                        ListElement {
                            value: "en"
                            text: qsTr("English")
                        }
                        ListElement {
                            value: "ru"
                            text: qsTr("Russian")
                        }
                    }
                    textRole: "text"
                    valueRole: "value"

                    onActivated: {
                        Language.set(currentValue)
                        Config.settings.language = currentValue
                    }

                    Component.onCompleted: {
                        currentIndex = indexOfValue(Config.settings.language)
                    }
                }
            }
        }

        Button {
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: qsTr("Sign out")
            onClicked: signOut()
        }
    }
}
