import QtQuick 2.15
import "../components"
import "../scripts/scripts.js" as Scripts

Rectangle {
    id: egePage

    property color backgroundColor: "#ffffff"

    implicitWidth: 1280
    implicitHeight: 720
    color: backgroundColor

    DropArea {
        anchors.fill: parent

        onDropped: {
            if (drop.hasUrls && drop.urls.length === 1) {
                let filePath = drop.urls[0]
                if (Scripts.validateTextFile(filePath)) {
                    console.log(Scripts.dropScheme(filePath))
                }
            }
        }
    }

    //    FileDialog {
    //        id: fileDialog
    //        title: "Please choose a file"
    //        nameFilters: ["Text files (*.txt)"]
    //        folder: shortcuts.home
    //        onAccepted: {
    //            console.log(fileDialog.fileUrl)
    //        }
    //        onRejected: {
    //            console.log("rejected")
    //        }
    //    }

    //    Button {
    //        text: qsTr("asdad")
    //        onClicked: {
    //            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/24", TokenManager.getToken())
    //            netManager.makeMultipartRequest("GET", [{"Content-Type": "application/json", "Body": JSON.stringify({"type": 1})}])
    //            netManager.finished.connect(function(err, data) {
    //                console.log(err, data)
    //            })
    //        }
    //    }
}
