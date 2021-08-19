import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: detailsPage
    property var song
    property var language: {
        //: Latin language
        'lat': qsTr("Latäin"),
        //: Luxembourgish language
        'ltz': qsTr("Lëtzebuergesch"),
        //: French language
        'fra': qsTr("Franséisch"),
        //: German language
        'deu': qsTr("Däitsch"),
        //: English language
        'eng': qsTr("Englesch")
    }

    onStatusChanged: if (status === PageStatus.Active) appSettings.setValue("interactionHint", false)

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: Details about the song
                title: qsTr("Detailer iwwer d'Lidd")
            }

            DetailItem {
                //: Song name
                label: qsTr("Titel")
                value: song.name? song.name: ""
                visible: value
            }
            DetailItem {
                //: Song number
                label: qsTr("Nummer")
                value: song.number? song.number: ""
                visible: value
            }
            DetailItem {
                //: Way of the melody
                label: qsTr("Aart aweis")
                value: song.way? song.way: ""
                visible: value
            }
            DetailItem {
                //: Language of the text
                label: qsTr("Sprooch")
                value: song.language? language[song.language]? language[song.language]: song.language: ""
                visible: value
            }
            DetailItem {
                //: Category of the song
                label: qsTr("Kategorie")
                value: song.category? song.category: ""
                visible: value
            }
            DetailItem {
                //: Release year of the song
                label: qsTr("Joer")
                value: song.year? song.year: ""
                visible: value
            }
            DetailItem {
                //: Last update to the content
                label: qsTr("Aktualiséiert")
                value: song.update_time? new Date(song.update_time*1000).toLocaleDateString(Qt.locale(), "dd.MM.yyyy"): ""
                visible: value
            }

            SectionHeader {
                //: Authors
                text: qsTr("Auteuren")
                visible: (song.lyrics_author || song.melody_author)? true: false
            }
            DetailItem {
                //: Lyrics author
                label: qsTr("Text")
                value: song.lyrics_author? song.lyrics_author: ""
                visible: value
            }
            DetailItem {
                //: Melody author
                label: qsTr("Melodie")
                value: song.melody_author? song.melody_author: ""
                visible: value
            }

            SectionHeader {
                //: Link to the website containing the songtext
                text: qsTr("Link")
                visible: song.url? true: false
            }
            Row {
                x: Theme.horizontalPageMargin
                width: column.width - 2 * Theme.horizontalPageMargin
                visible: song.url
                LinkedLabel {
                    width: parent.width - clipboardButton.width
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.Wrap
                    plainText: visible? song.url: ""
                }
                IconButton {
                    id: clipboardButton
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: "image://theme/icon-m-clipboard?" + (pressed ? Theme.highlightColor : Theme.primaryColor)
                    enabled: Clipboard.text !== song.url
                    onClicked: Clipboard.text = song.url
                }
            }
        }

        ScrollDecorator {  }
    }
}
