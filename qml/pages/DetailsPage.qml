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
                title: song.name
            }

            Component {
                id: propertyComponent

                Row {
                    width: column.width
                    spacing: Theme.paddingMedium
                    x: Theme.horizontalPageMargin
                    Label {
                        id: propertyLabel
                        text: propertyDesc
                        color: Theme.secondaryColor
                    }
                    Label {
                        text: propertyValue
                        truncationMode: TruncationMode.Fade
                        width: column.width - Theme.horizontalPageMargin - propertyLabel.contentWidth - Theme.paddingMedium
                    }
                }
            }

            Loader {
                //: Song number
                property string propertyDesc: qsTr("Nummer")
                property var propertyValue: song.number
                sourceComponent: { song.number? propertyComponent: null }
            }
            Loader {
                //: Way of the melody
                property string propertyDesc: qsTr("Aart aweis")
                property var propertyValue: song.way
                sourceComponent: { song.way? propertyComponent: null }
            }
            Loader {
                //: Language of the text
                property string propertyDesc: qsTr("Sprooch")
                property var propertyValue: language[song.language]? language[song.language]: song.language
                sourceComponent: { song.language? propertyComponent: null }
            }
            Loader {
                //: Category of the song
                property string propertyDesc: qsTr("Kategorie")
                property var propertyValue: song.category
                sourceComponent: { song.category? propertyComponent: null }
            }
            Loader {
                //: Release year of the song
                property string propertyDesc: qsTr("Joer")
                property var propertyValue: song.year
                sourceComponent: { song.year? propertyComponent: null }
            }

            SectionHeader {
                //: Authors
                text: qsTr("Auteuren")
                visible: (song.lyrics_author || song.melody_author)? true: false
            }
            Loader {
                //: Lyrics author
                property string propertyDesc: qsTr("Text")
                property var propertyValue: song.lyrics_author
                sourceComponent: { song.lyrics_author? propertyComponent: null }
            }
            Loader {
                //: Melody author
                property string propertyDesc: qsTr("Melodie")
                property var propertyValue: song.melody_author
                sourceComponent: { song.melody_author? propertyComponent: null }
            }

            SectionHeader {
                //: Online features
                text: qsTr("Online")
                visible: song.url? true: false
            }
            Row {
                width: column.width
                spacing: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                visible: song.url? true: false
                Label {
                    id: propertyLabel
                    color: Theme.secondaryColor
                    //: URL to the website
                    text: qsTr("Link")
                }
                Label {
                    width: column.width - Theme.horizontalPageMargin - propertyLabel.contentWidth - Theme.paddingMedium
                    linkColor: Theme.highlightColor
                    wrapMode: Text.Wrap
                    onLinkActivated: Qt.openUrlExternally(link)
                    text: "<a href=\"" + song.url + "\">" + song.url + "</a>"
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: Clipboard.text !== song.url
                onClicked: Clipboard.text = song.url
                //: Copy to clipboard
                text: qsTr("An d'Tëschenoflag kopéieren")
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                visible: Clipboard.text === song.url
                //: Text is already in clipboard
                text: qsTr("(An der Tëschenoflag)")
            }
        }

        ScrollDecorator {  }
    }
}
