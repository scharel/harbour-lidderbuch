import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                //: Header of the About page
                title: qsTr("Iwwer d'App")
            }

            Row {
                x: Theme.horizontalPageMargin
                spacing: Theme.paddingMedium
                //: App version
                Label { text: qsTr("Versioun"); color: Theme.secondaryColor }
                Label { text: "1.1-3"; color: Theme.highlightColor }
            }

            Image {
                source: "harbour-lidderbuch.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                fillMode: Image.PreserveAspectFit
            }
            Text {
                x: Theme.horizontalPageMargin
                width: parent.width - x
                color: Theme.secondaryColor
                linkColor: Theme.highlightColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                //: Disclaymer by ACEL
                text: qsTr("Dës App benotzt Liddtexter vun der ACEL (<a href=\"https://acel.lu\">https://acel.lu</a>) mat Hëllef vun der AcelApi (<a href=\"https://github.com/AcelLuxembourg/AcelApi\">https://github.com/AcelLuxembourg/AcelApi</a>). D'ACEL ass net den Entwéckler an domadder och net Verantwortlech fir den Ënnerhalt vun der App.")
            }
            Separator {
                width: parent.width
                color: Theme.secondaryColor
            }
            Text {
                x: Theme.horizontalPageMargin
                width: parent.width - x
                color: Theme.secondaryColor
                linkColor: Theme.highlightColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                //: Possibilities to report issues
                text: qsTr("Fehler oder Verbesserungsvirschléi kennen am Jolla Store oder op <a href=\"https://github.com/scharel/harbour-lidderbuch/issues\">GitHub</a> gemellt ginn.<br />© Scharel Clemens 2017")
            }
        }

        ScrollDecorator {  }
    }
}
