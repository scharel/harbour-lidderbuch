import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        Image {
            source: "logo.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*Theme.horizontalPageMargin
            fillMode: Image.PreserveAspectFit
        }
        Label {
            text: qsTr("ACEL")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
        Label {
            //: App name on the cover
            text: qsTr("Lidderbuch")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }

    }

    /*CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
        }
    }*/
}


