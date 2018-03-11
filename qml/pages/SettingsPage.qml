import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage

    SilicaFlickable {
        id: silicaFlickable
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                //: Pulldown menu item to the About page
                text: qsTr("Iwwer d'App")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: column

            width: parent.width

            PageHeader {
                //: Header of the settings page
                title: qsTr("Astellungen")
            }

            SectionHeader {
                //: Section to update the song texts
                text: qsTr("Lidder aktualiséieren")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingLarge

                Row {
                    width: parent.width
                    spacing: Theme.paddingMedium
                    x: Theme.horizontalPageMargin
                    Label {
                        id: updateLabel
                        //: DateTime of the last update
                        text: qsTr("Leschten Update")
                        color: Theme.secondaryColor
                    }
                    Label {
                        id: timeLabel
                        Timer { id: errorTimer; onTriggered: songModel.status = 200 }
                        Connections { target: songModel; onStatusChanged: songModel.status === 200 ? errorTimer.stop() : errorTimer.restart() }
                        text: errorTimer.running ?
                                  //: Error               //: Status
                                  qsTr("Feeler") + " (" + qsTr("Status") + " " + songModel.status + ")" :
                                  (appSettings.songsUpdate.valueOf() === 0 ?
                                      //: never
                                      qsTr("nach ni") :
                                      appSettings.songsUpdate.toLocaleString(Qt.locale(), "dd.MM.yyyy hh:mm:ss"))
                        visible: !songModel.busy
                        color: Theme.highlightColor
                        width: parent.width - x
                        wrapMode: Text.Wrap
                    }
                    BusyIndicator {
                        id: updateBusy
                        running: songModel.busy
                        size: BusyIndicatorSize.Small
                    }
                }
                Button {
                    //: Update song texts
                    text: qsTr("Lo aktualiséierten")
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: !songModel.busy
                    onClicked: songModel.update()
                }
            }

            SectionHeader {
                //: Section to manipulate the look of the SongPage
                text: qsTr("Ausgesinn vun den Lidder-Texter")
            }
            ComboBox {
                //: Font size for the song page
                label: qsTr("Schrëftgréisst")
                currentIndex: appSettings.fontSize

                menu: ContextMenu {
                    //: Small font size
                    MenuItem { text: qsTr("Kleng") }
                    //: Medium font size
                    MenuItem { text: qsTr("Mëttel") }
                    //: Large font size
                    MenuItem { text: qsTr("Grouss") }
                    //: Extra large font size
                    MenuItem { text: qsTr("Ech si voll") }
                    onActivated: appSettings.setValue("fontSize", index)
                }
            }
            ComboBox {
                //: Colors for the song page
                label: qsTr("Faarwen")
                currentIndex: appSettings.colorTheme

                menu: ContextMenu {
                    //: SailfishOS color theme
                    MenuItem { text: qsTr("Standard") }
                    //: Dark color theme
                    MenuItem { text: qsTr("Däischter") }
                    //: Black on white color theme
                    MenuItem { text: qsTr("Schwaarz op Wäiss") }
                    //: Green on black color theme
                    MenuItem { text: qsTr("Matrix") }
                    onActivated: appSettings.setValue("colorTheme", index)
                }
            }

            SectionHeader {
                text: "Debug"
                visible: debug
            }
            Button {
                text: "Reset"
                visible: debug
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    appSettings.clear()
                    songModel.flush()
                }
            }
        }

        ScrollDecorator { }
    }
}
