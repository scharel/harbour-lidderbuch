import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: songsPage

    BusyIndicator {
        id: busyIndicator
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: songModel.busy
    }

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {
            busy: songModel.busy
            MenuItem {
                text: qsTr("Iwwer d'App")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Astellungen")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Aktualiséieren")
                onClicked: songModel.update()
            }
        }

        header: PageHeader {
            title: qsTr("ACEL Lidderbuch")
            /*SearchField {
            width: parent.width
            placeholderText: qsTr("Songs")
            enabled: !busyIndicator.running

            onTextChanged: {
                console.log("Search: " + text)
                //songsModel.query = text !== "" ? "$.[?(@.name like '" + text + "')]" : ""
            }*/
        }

        model: SongModel {
            id: songModel
        }

        delegate: ListItem {
            id: song
            width: parent.width
            height: Theme.itemSizeSmall
            onClicked: pageStack.push(Qt.resolvedUrl("SongPage.qml"), {song: model})

            Row {
                width: parent.width
                spacing: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: songNumber
                    text: model.number
                    width: Theme.iconSizeSmall
                    color: song.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    opacity: model.number === 0 ? 0 : 1
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

        VerticalScrollDecorator {}
    }
}
