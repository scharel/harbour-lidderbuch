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

            /* obsolete
            SectionHeader {
                //: General settings
                text: qsTr("Allgemeng")
            }
            ComboBox {
                //: Starting page of the app
                label: qsTr("Startsäit")
                currentIndex: appSettings.startPage

                menu: ContextMenu {
                    //: Songtexts
                    MenuItem { text: qsTr("Lidderbuch") }
                    //: Events
                    MenuItem { text: qsTr("Agenda") }
                    //: Last used
                    MenuItem { text: qsTr("Lescht benotzten Säit") }
                    onActivated: {
                        appSettings.setValue("startPage", index)
                        switch(appSettings.startPage) {
                        case(0):
                            pageStack.clear()
                            pageStack.push(songsPage)
                            break;
                        case(1):
                            pageStack.clear()
                            pageStack.push(eventsPage)
                            break;
                        default:
                            pageStack.pop()
                            break;
                        }
                    }
                }
            }
            TextSwitch {
                //: Alternative API
                text: qsTr("Alternativ API")
                //: Use this if you have problems with the API
                description: qsTr("A gewësse Fäll kann et zu Problemer mat der API kommen. Sollten sech d'Liddertexter oder d'Agenda net aktualiséieren loossen, kann dëst ausprobéiert ginn.")
                checked: appSettings.alternativeAPI
                onCheckedChanged: appSettings.setValue("alternativeAPI", checked)
            }
            */

            SectionHeader {
                //: Section to update the songs
                text: qsTr("Lidderbuch")
            }
            Column {
                width: parent.width
                spacing: Theme.paddingMedium
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
                            onTriggered: songModel.status = 200
                        }
                        Connections {
                            target: songModel;
                            onStatusChanged: songModel.status === 200 ? songErrorTimer.stop() : songErrorTimer.restart()
                        }
                        text: songErrorTimer.running ?
                                  //: Error               //: Status
                                  qsTr("Feeler") + " (" + qsTr("Status") + " " + songModel.status + ")" :
                                  (appSettings.songsUpdate.valueOf() === 0 ?
                                      //: never
                                      qsTr("nach ni") :
                                      appSettings.songsUpdate.toLocaleString(Qt.locale(), "dd.MM.yyyy hh:mm:ss"))
                        visible: !songModel.busy
                        color: Theme.secondaryHighlightColor
                        width: parent.width - x
                        wrapMode: Text.Wrap
                    }
                    BusyIndicator {
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
