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

            Label {
                x: Theme.horizontalPageMargin
                text: "© Scharel Clemens 2016"
            }
            Label {
                x: Theme.horizontalPageMargin
                text: "Content provided by ACEL"
            }
        }

        ScrollDecorator {  }
    }
}
