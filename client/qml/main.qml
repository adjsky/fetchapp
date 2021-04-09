import QtQuick 2.15
import QtQuick.Controls 2.15
import Config 1.0
import Language 1.0
import "components"

ApplicationWindow {
    id: appWindow

    property color backgroundColor: "#33383c"
    property color sidebarColor: "#41484b"

    width: 640
    minimumWidth: 640
    height: 720
    minimumHeight: 720
    visible: true
    opacity: 0
    title: Qt.application.name

    QtObject {
        id: internal
        property SidebarItem currentActive: homeButton
        property QtObject loginWindow

        function makeActive(item) {
            if (currentActive) {
                currentActive.active = false
            }
            currentActive = item
            item.active = true
        }

        function initialize() {
            Language.set(Config.settings.language)
            let loginComponent = Qt.createComponent("Login.qml")
            loginWindow = loginComponent.createObject(appWindow)
            loginWindow.success.connect(() => {
                loginWindow.opacity = 0
                appWindow.opacity = 1
            })
            loginWindow.exit.connect(() => {
                appWindow.close()
            })
            loginWindow.opacity = 0
        }

        function showLoginWindow() {
            internal.loginWindow.opacity = 1
        }
    }

    Rectangle {
        id: background
        color: backgroundColor
        anchors.fill: parent

        Rectangle {
            id: sideBar
            width: 50
            height: parent.height
            color: sidebarColor

            Column {
                spacing: 0

                SidebarItem {
                    id: homeButton
                    width: sideBar.width
                    height: sideBar.width
                    iconPath: Qt.resolvedUrl("images/home.svg")
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
                    width: sideBar.width
                    height: sideBar.width
                    iconPath: Qt.resolvedUrl("images/book.svg")
                    iconWidth: 24
                    iconHeight: 24
                    onClicked: {
                        internal.makeActive(egeButton)
                        pageLoader.source = "pages/EgePage.qml"
                    }
                }
            }

            SidebarItem {
                id: settingsButton
                width: sideBar.width
                height: sideBar.width
                anchors.bottom: parent.bottom
                iconPath: Qt.resolvedUrl("images/settings.svg")
                iconWidth: 24
                iconHeight: 24
                onClicked: {
                    internal.makeActive(settingsButton)
                    pageLoader.source = "pages/SettingsPage.qml"
                }
            }
        }

        Loader {
            id: pageLoader
            anchors.fill: parent
            anchors.leftMargin: sideBar.width
            source: "pages/HomePage.qml"
        }
    }

    Component.onCompleted: {
        internal.initialize()
        internal.showLoginWindow()
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
