import QtQuick 2.15
import QtQuick.Controls 2.15
import UserManager 1.0
import Qt.labs.platform 1.1 as Platform
import "../scripts/scripts.js" as Scripts
import "../scripts/constants.js" as Constants
import "../components"

Rectangle {
    id: egePage

    property color backgroundColor: "#ffffff"

    implicitWidth: 640
    implicitHeight: 720
    color: backgroundColor

    QtObject {
        id: internal

        property bool resultButtonEnabled: {
            switch (questionsList.currentText) {
            case "24":
                if (questionTypesList.currentValue === "3") {
                    filePathInput.text !== "" && charInput.text !== ""
                } else {
                    filePathInput.text !== ""
                }
                break
            default:
                false
            }
        }

        property bool detailsRowVisible: {
            questionsList.currentText === "24" && questionTypesList.currentValue === "3"
        }

        function getServerData() {
            setQuestionsModel()
        }

        function setFilePath(path) {
            filePathInput.text = Scripts.dropScheme(path)
        }

        function setQuestionsModel() {
            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/available")
            netManager.setAuthToken(UserManager.getToken())
            netManager.finished.connect((error, data) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code === 200) {
                                                    let model = response["questions_available"].split(", ")
                                                    if (model.length !== 0) {
                                                        questionsList.model = model
                                                        setQuestionTypesModel(model[0])
                                                    }
                                                } else {
                                                    console.log(response.message)
                                                }
                                            }
                                            else {
                                                console.log(error, data)
                                            }
                                        })
            netManager.makeRequest("GET")
        }

        function setQuestionTypesModel(question_number) {
            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/" + question_number + "/types")
            netManager.setAuthToken(UserManager.getToken())
            netManager.finished.connect((error, data) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code === 200) {
                                                    let model = []
                                                    let listData = JSON.parse(data)["types_available"].split("\n")
                                                    listData.forEach(data => {
                                                                        let info = Scripts.splitByIndex(data, data.indexOf(" "))
                                                                        let type = info[0]
                                                                        let desc = info[1]
                                                                        model.push({"type": type, "desc": desc})
                                                                     })
                                                    questionTypesList.model = model
                                                    showPage()
                                                } else {
                                                    console.log(response.message)
                                                }
                                            }
                                            else {
                                                console.log(error)
                                            }
                                        })
            netManager.makeRequest("GET")
        }

        function showPage() {
            busyIndicator.running = false
            pageContent.opacity = 1
        }

        function getResultFromServer() {
            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/" + questionsList.currentValue)
            netManager.setAuthToken(UserManager.getToken())
            let body = {"type": parseInt(questionTypesList.currentValue)}
            if (questionTypesList.currentValue === "3") {
                body.char = charInput.text
            }
            netManager.makeMultipartRequest("POST", [{"Content-Type": "application/json",
                                                      "Body": JSON.stringify(body)
                                                     },
                                                     {"Content-Type": "text/plain",
                                                      "Body": Scripts.fileScheme + filePathInput.text
                                                     }])
            netManager.finished.connect(function(err, data) {
                if (err === "") {
                    let response = JSON.parse(data)
                    if (response["code"] === 200) {
                        popup.text = qsTr("Result is") + ": " + JSON.parse(data)["result"]
                        popup.open()
                    } else {
                        console.log(err, data)
                    }
                } else {
                    console.log(err, data)
                }
            })
        }
    }

    Item {
        id: pageContent
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }

        DropArea {
            anchors.fill: parent

            onDropped: {
                if (drop.hasUrls && drop.urls.length === 1) {
                    let filePath = String(drop.urls[0])
                    if (Scripts.validateTextFile(filePath)) {
                        internal.setFilepath(filePath)
                    }
                }
            }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Column {
                width: parent.width
                height: parent.height - resultButton.height - resultButton.anchors.bottomMargin
                spacing: 10

                Row {
                    width: parent.width
                    height: 35
                    spacing: 5

                    TextField {
                        id: filePathInput
                        width: parent.width - openButton.width - parent.spacing
                        height: parent.height
                        leftPadding: 5
                        selectByMouse: true
                    }

                    Button {
                        id: openButton
                        text: qsTr("Open")
                        height: parent.height

                        onPressed: {
                            fileDialog.open()
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 35
                    spacing: 5

                    ComboBox {
                        id: questionsList
                        width: 80
                        height: parent.height
                        enabled: currentIndex != -1
                        onActivated: {
                            internal.setQuestionTypesModel(model[index])
                        }
                    }

                    ComboBox {
                        id: questionTypesList
                        width: parent.width - questionsList.width - parent.spacing
                        height: parent.height
                        enabled: questionsList.currentIndex != -1
                        valueRole: "type"
                        textRole: "desc"

                        contentItem: Text {
                            leftPadding: 12
                            verticalAlignment: Text.AlignVCenter
                            text: qsTranslate("backend", questionTypesList.displayText)
                        }

                        delegate: ItemDelegate {
                            contentItem: Text {
                                text: qsTranslate("backend", modelData.desc)
                            }
                        }
                    }
                }

                Row {
                    id: detailsRow
                    width: parent.width
                    height: 30
                    spacing: 5
                    visible: internal.detailsRowVisible

                    Item {
                        width: charLabel.width + charInput.width + 5
                        height: parent.height

                        Label {
                            id: charLabel
                            height: parent.height
                            font.pixelSize: 13
                            text: qsTr("Letter")
                            verticalAlignment: Text.AlignVCenter
                        }

                        TextField {
                            id: charInput
                            leftPadding: 10
                            width: 30
                            height: parent.height
                            anchors.right: parent.right
                            font.pixelSize: 13
                            maximumLength: 1
                        }
                    }
                }
            }

            Button {
                id: resultButton
                text: qsTr("Get the result")
                enabled: internal.resultButtonEnabled
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                onClicked: {
                    internal.getResultFromServer()
                }
            }
        }
    }

    CustomBusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
    }

    Platform.FileDialog {
        id: fileDialog
        title: qsTr("Please choose a file")
        fileMode: Platform.FileDialog.OpenFile
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            internal.setFilePath(String(fileDialog.file))
        }
    }

    Platform.MessageDialog {
        id: popup
        title: qsTr("Result")
    }

    Component.onCompleted: {
        internal.getServerData()
    }
}
