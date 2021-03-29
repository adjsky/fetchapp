import QtQuick 2.15
import QtQuick.Controls 2.15
import TokenManager 1.0
import Qt.labs.platform 1.1 as Platform
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

        function setFilePath(path) {
            filePathInput.text = Scripts.dropScheme(path)
        }

        function setQuestionsModel() {
            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/available")
            netManager.setAuthToken(TokenManager.getToken())
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
            netManager.setAuthToken(TokenManager.getToken())
            netManager.finished.connect((error, data) => {
                                            if (error === "") {
                                                let response = JSON.parse(data)
                                                if (response.code === 200) {
                                                    let model = []
                                                    let listData = JSON.parse(data)["types_available"].split("\n")
                                                    listData.forEach(data => {
                                                                        let typeInfo = Scripts.splitByIndex(data, data.indexOf(" "))
                                                                        model.push({"type": typeInfo[0], "desc": typeInfo[1]})
                                                                     })
                                                    questionTypesList.model = model
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

        function getResultFromServer() {
            let netManager = new NetworkManager(Constants.serverPath + "/api/ege/" + questionsList.currentValue)
            netManager.setAuthToken(TokenManager.getToken())
            netManager.makeMultipartRequest("POST", [{"Content-Type": "application/json",
                                                      "Body": JSON.stringify({"type": 1})
                                                     },
                                                     {"Content-Type": "text/plain",
                                                      "Body": Scripts.fileScheme + filePathInput.text
                                                     }])
            netManager.finished.connect(function(err, data) {
                if (err === "") {
                    popup.text = "Result is: " + JSON.parse(data)["result"]
                    popup.open()
                } else {
                    console.log(err, data)
                }
            })
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

    Column {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 20
        spacing: 10

        Row {
            width: parent.width
            height: 35
            spacing: 5

            UserInput {
                id: filePathInput
                width: parent.width - button.width - parent.spacing
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

        Row {
            width: parent.width
            height: questionsList.height
            spacing: 5

            ComboBox {
                id: questionsList
                width: 80
                enabled: currentIndex != -1
                onActivated: {
                    internal.setQuestionTypesModel(model[index])
                }
            }

            ComboBox {
                id: questionTypesList
                width: parent.width - questionsList.width - parent.spacing
                enabled: questionsList.currentIndex != -1
                valueRole: "type"
                textRole: "desc"
            }
        }

        Button {
            text: "Get the result"
            enabled: filePathInput.text != ""
            onClicked: {
                internal.getResultFromServer()
            }
        }
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
        internal.setQuestionsModel()
    }
}
