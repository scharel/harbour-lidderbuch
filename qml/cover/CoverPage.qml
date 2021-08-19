import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        id: coverColumn
        width: parent.width
        spacing: Theme.paddingSmall
        Image {
            source: "logo.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 2*Theme.horizontalPageMargin
            fillMode: Image.PreserveAspectFit
            visible: appSettings.lastPage !== 1 || eventModel.count === 0
        }
        Label {
            id: coverTitle
            //: App name on the cover
            text: qsTr("ACEL") +
                  (appSettings.lastPage !== 1 ?
                       "\n" + qsTr("Lidderbuch") :
                       " " + qsTr("Agenda"))
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
        }
    }

    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: appWindow.doFocusOnSearch()
        }
    }
}


