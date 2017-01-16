import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settingsPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: parent.width

            PageHeader {
                //: Header of the settings page
                title: qsTr("Astellungen")
            }

            SectionHeader {
                //: Section to update the song texts
                text: qsTr("Aktualiséieren")
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
                        //: DateTime shown while updating
                        text: appSettings.lastUpdate
                        color: Theme.highlightColor
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
                    down: songModel.busy
                    onClicked: songModel.update()
                }
            }

            SectionHeader {
                //: Section to manipulate the look of the SongPage
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

            /*
            ComboBox {
                //: Font color for the song page
                label: qsTr("Schrëftfaarf")
                //currentIndex: appSettings.fontColor

                menu: ContextMenu {
                    //: SailfishOS color theme
                    MenuItem { text: qsTr("Standard") }
                    //: Choose custom color
                    MenuItem { text: qsTr("Faarf eraussichen") }
                    onActivated: {
                        if (index === 0) {
                            appSettings.setValue("fontColor", Theme.primaryColor)
                        }
                        else {
                            var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                            dialog.accepted.connect(function() {
                                appSettings.setValue("fontColor", dialog.color)
                            })
                        }
                    }
                }
            }
            */
        }

        ScrollDecorator {  }
    }
}
