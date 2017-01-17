import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: songsPage
    property var song
    property int fontSize : Theme.fontSizeMedium
    property color fontColor: Theme.primaryColor
    property color bgColor: "transparent"
    Component.onCompleted: {
        switch(appSettings.fontSize) {
        case 0:
            fontSize = Theme.fontSizeSmall
            break;
        case 2:
            fontSize = Theme.fontSizeLarge
            break;
        case 3:
            fontSize = Theme.fontSizeExtraLarge
            break;
        default: // also 1
            fontSize = Theme.fontSizeMedium
            break;
        }

        switch(appSettings.colorTheme) {
        case 1:
            fontColor = Theme.highlightColor
            bgColor = "black"
            break;
        case 2:
            fontColor = "black"
            bgColor = "white"
            break;
        case 3:
            fontColor = "#00FF00"
            bgColor = "black"
            break;
        default:    // also 0
            fontColor = Theme.primaryColor
            bgColor = "transparent"
            break;
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent

        header: PageHeader {
            title: song.name
        }

        model: song.paragraphs

        delegate: Item {
            id: delegateItem
            width: parent.width
            height: content.height + Theme.paddingLarge
            Rectangle
            {
                anchors.fill: delegateItem
                color: songsPage.bgColor
            }
            Text {
                id: content
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                anchors.verticalCenter: parent.verticalCenter
                color: songsPage.fontColor
                font.family: Theme.fontFamily
                font.pixelSize: songsPage.fontSize
                wrapMode: Text.Wrap
                text: model.content
            }
        }

        Rectangle { // fill the remaining background
            width: parent.width
            height: songsPage.height - listView.contentHeight
            anchors.bottom: parent.bottom
            color: songsPage.bgColor
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
