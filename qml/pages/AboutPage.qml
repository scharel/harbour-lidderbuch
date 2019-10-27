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
                Label { text: qsTr("Versioun"); color: Theme.primaryColor }
                Label { text: "2.5-1"; color: Theme.highlightColor }
                Label { text: qsTr("Debug-Modus"); visible: debug; color: Theme.secondaryColor }
            }

            Image {
                source: "harbour-lidderbuch.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge
                fillMode: Image.PreserveAspectFit
            }
            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - x
                linkColor: Theme.highlightColor
                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                //: Disclaymer by ACEL
                text: qsTr("Dës App benotzt Liddtexter vun der ACEL (<a href=\"https://acel.lu\">https://acel.lu</a>) mat Hëllef vun der AcelApi (<a href=\"https://github.com/AcelLuxembourg\">https://github.com/AcelLuxembourg</a>). D'ACEL ass net den Entwéckler an domadder och net Verantwortlech fir den Ënnerhalt vun der App.")
            }
            Separator {
                width: parent.width
                color: Theme.secondaryColor
            }
            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - x
                linkColor: Theme.highlightColor
                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
                //: Possibilities to report issues
                text: qsTr("Fehler oder Verbesserungsvirschléi kennen am Jolla Store oder op <a href=\"https://github.com/scharel/harbour-lidderbuch/issues\">GitHub</a> gemellt ginn.<br />© Scharel Clemens") + " " + new Date().toLocaleString(Qt.locale(), "yyyy")
            }
        }

        ScrollDecorator {  }
    }
}
