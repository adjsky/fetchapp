import QtQuick 2.15
import QtQuick.Controls 2.15
import TokenManager 1.0
import QtQuick.Dialogs 1.2
import "../components"
import "../scripts/scripts.js" as Scripts
import "../scripts/constants.js" as Constants

Rectangle {
    id: egePage

    property color backgroundColor: "#ffffff"

    implicitWidth: 640
    implicitHeight: 720
    color: backgroundColor

    QtObject {
        id: internal

        function setFilepath(path) {
            filePathInput.text = Scripts.dropScheme(path)
        }
    }

    DropArea {
        anchors.fill: parent

        onDropped: {
            if (drop.hasUrls && drop.urls.length === 1) {
                let filePath = drop.urls[0]
                if (Scripts.validateTextFile(filePath)) {
                    internal.setFilepath(filePath)
                }
            }
        }
    }

    Column {
        width: 300
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0

        Row {
            width: parent.width
            height: 35

            UserInput {
                id: filePathInput
                width: parent.width - button.width
                height: parent.height
                leftPadding: 5
            }
            Button {
                id: button
                text: qsTr("Open")
                height: parent.height

                onPressed: {
                    fileDialog.open()
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["Text files (*.txt)"]
        folder: shortcuts.home
        onAccepted: {
            internal.setFilepath(fileDialog.fileUrls[0])
        }
    }

//        Button {
//            text: qsTr("asdad")
//            onClicked: {
//                let netManager = new NetworkManager(Constants.serverPath + "/api/ege/24")
//                netManager.setAuthToken(TokenManager.getToken())
//                netManager.makeMultipartRequest("GET", [{"Content-Type": "application/json", "Body": JSON.stringify({"type": 1})},
//                                                        {"Content-Type": "text/plain", "Body": "file:///home/adjsky/test.txt"}])
//                netManager.finished.connect(function(err, data) {
//                    console.log(err, data)
//                })
//            }
//        }
}
