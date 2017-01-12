import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: songsPage
    property var song

    SilicaListView {
        anchors.fill: parent

        header: PageHeader {
            title: song.name
        }

        model: song.paragraphs

        delegate: Item {
            width: parent.width
            height: content.height + 2*Theme.paddingMedium
            Text {
                id: content
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                color: Theme.primaryColor
                font.family: Theme.fontFamily
                font.pixelSize: (appSettings.fontSize === 0) ? Theme.fontSizeSmall : (appSettings.fontSize === 1) ? Theme.fontSizeMedium : (appSettings.fontSize === 2) ? Theme.fontSizeLarge : (appSettings.fontSize === 3) ? Theme.fontSizeExtraLarge : Theme.fontSizeMedium
                wrapMode: Text.Wrap
                text: model.content
            }
        }

        VerticalScrollDecorator {}
    }
}
