import QtQuick 2.15
import QtQuick.Controls 2.15
import "components"
import "scripts/constants.js" as Constants

ApplicationWindow {
    id: appWindow

    property color backgroundColor: "#33383c"
    property color sidebarColor: "#41484b"

    width: 640
    minimumWidth: 640
    height: 720
    minimumHeight: 720
    visible: true
    title: qsTr("fetchapp")

    QtObject {
        id: internal
        property SidebarItem currentActive: homeButton

        function makeActive(item) {
            if (currentActive) {
                currentActive.active = false
            }
            currentActive = item
            item.active = true
        }
    }

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: sidebar
            width: 50
            height: parent.height
            color: sidebarColor

            Column {
                spacing: 0

                SidebarItem {
                    id: homeButton
                    width: sidebar.width
                    height: sidebar.width
                    iconPath: "images/home.svg"
                    iconWidth: 24
                    iconHeight: 24
                    active: true
                    onClicked: {
                        internal.makeActive(homeButton)
                        pageLoader.source = "pages/HomePage.qml"
                    }
                }

                SidebarItem {
                    id: egeButton
                    width: sidebar.width
                    height: sidebar.width
                    iconPath: "images/book.svg"
                    iconWidth: 24
                    iconHeight: 24
                    onClicked: {
                        internal.makeActive(egeButton)
                        pageLoader.source = "pages/EgePage.qml"
                    }
                }
            }
        }

        Loader {
            id: pageLoader
            anchors.fill: parent
            anchors.leftMargin: sidebar.width
            source: "pages/HomePage.qml"
        }
    }

    Component.onCompleted: {
//        let loginComponent = Qt.createComponent("Login.qml")
//        let loginWindow = loginComponent.createObject(appWindow)
//        loginWindow.tokenReceived.connect(function() {
//            loginWindow.destroy()
//            appWindow.show()
//        })
//        loginWindow.exitPressed.connect(function() {
//            loginWindow.destroy()
//            appWindow.visible = true
//            appWindow.close()
//        })
//        loginWindow.show()
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
