import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page {
    id: songsPage
    property var song
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-lidderbuch/settings"
        //property int appLanguage
        property int fontSize
    }

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                //: Show details
                text: qsTr("Méi Informatiounen")
                onClicked: pageStack.push(Qt.resolvedUrl("DetailsPage.qml"), {song: song})
            }
        }

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
                width: parent.width - x
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
