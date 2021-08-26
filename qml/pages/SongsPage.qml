import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: firstPage

    onStatusChanged: {
        if (status === PageStatus.Active) {
            appSettings.setValue("songsHint", false)
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent

        PullDownMenu {
            busy: api.busy
            MenuItem {
                //: Pulldown menu item to the settings page
                text: qsTr("Astellungen")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        header: SearchField {
            width: parent.width
            //: Page Header
            placeholderText: qsTr("ACEL Lidderbuch")
            onTextChanged: {
                songModel.search(text.toLowerCase())
            }
            Connections {
                target: appWindow
                onCoverSearchTriggered: forceActiveFocus()
            }

            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: focus = false
            enabled: songModel.json.length > 0
        }

        model: songModel
        currentIndex: -1

        delegate: ListItem {
            id: song
            width: parent.width
            contentHeight: Theme.itemSizeSmall
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SongPage.qml"), {song: model})
                pageStack.pushAttached(Qt.resolvedUrl("DetailsPage.qml"), {song: model})
            }

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                spacing: Theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: songNumber
                    text: model.number === "" ? " – " : model.number
                    color: song.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                }

                Label {
                    id: songName
                    text: model.name
                    width: parent.width - songNumber.x - songNumber.width
                    truncationMode: TruncationMode.Fade
                    color: song.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            }
        }

        section.property: "category"
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            text: section
        }

        ViewPlaceholder {
            enabled: songModel.count === 0 && songModel.json.length > 0
            //: No songs found with search function
            text: qsTr("Keng Lidder fonnt")
            //: Try another search query
            hintText: qsTr("Probéier eng aner Sich.")
            verticalOffset: (firstPage.height - Screen.height) * 0.5
        }

        ViewPlaceholder {
            enabled: songModel.count === 0 && songModel.json.length === 0 && !songModel.busy
            //: No songs available
            text: qsTr("Keng Lidder verfügbar")
            //: Use the settings page to download content
            hintText: qsTr("An den Astellungen kennen d'Lidder nei erofgeluede ginn.")
            verticalOffset: (firstPage.height - Screen.height) * 0.5
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: songModel.count === 0 && api.busy
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
