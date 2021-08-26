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
                //: Section to update the songs
                text: qsTr("Lidderbuch")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingLarge
                Label {
                    width: parent.width - 2 * x
                    x: Theme.horizontalPageMargin
                    color: Theme.secondaryHighlightColor
                    wrapMode: Text.Wrap
                    //: Update description
                    text: qsTr("Wann néi Lidder vun der ACEL verëffentlecht gi sinn, kennen déi hei erofgeluede ginn.")
                }
                Button {
                    //: Update song texts
                    text: qsTr("Lo aktualiséierten")
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: !api.busy
                    onClicked: songModel.update()
                }
                Row {
                    width: parent.width
                    spacing: Theme.paddingMedium
                    x: Theme.horizontalPageMargin
                    Label {
                        //: DateTime of the last update
                        text: qsTr("Leschten Update")
                        color: Theme.secondaryColor
                    }
                    Label {
                        Timer {
                            id: songErrorTimer;
                            interval: 2000;
                            //onTriggered: songModel.status = 200
                        }
                        Connections {
                            target: api
                            onErrorChanged: api.error === 0 ? songErrorTimer.stop() : songErrorTimer.restart()
                        }
                        text: songErrorTimer.running ?
                                  //: Error               //: Status
                                  qsTr("Feeler") + " (" + qsTr("Status") + " " + api.error + ")" :
                                  (appSettings.songsUpdate.valueOf() === 0 ?
                                      //: never
                                      qsTr("nach ni") :
                                      appSettings.songsUpdate.toLocaleString(Qt.locale(), "dd.MM.yyyy hh:mm:ss"))
                        visible: !api.busy
                        color: Theme.secondaryHighlightColor
                        width: parent.width - x
                        wrapMode: Text.Wrap
                    }
                    BusyIndicator {
                        running: api.busy
                        size: BusyIndicatorSize.Small
                    }
                }
            }

            SectionHeader {
                //: Section of the song text settings
                text: qsTr("Ausgesinn")
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
                    eventModel.flush()
                    pageStack.clear()
                    pageStack.push(songsPage)
                }
            }
        }

        ScrollDecorator { }
    }
}
