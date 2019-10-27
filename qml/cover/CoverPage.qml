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

    /*SilicaListView {
        visible: appSettings.lastPage === 1
        width: parent.width
        anchors.top: coverColumn.bottom
        anchors.left: parent.left
        anchors.leftMargin: Theme.paddingMedium
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: eventModel
        currentIndex: -1
        delegate: Row {
            width: parent.width
            Label {
                text: new Date(start_time*1000).getDate() + ". "
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: name
                font.pixelSize: Theme.fontSizeExtraSmall
                width: parent.width - x
                color: Theme.secondaryColor
                truncationMode: TruncationMode.Fade
            }
        }

        section.property: "section"
        section.delegate: Label {
            text: section
            anchors.right: parent.right
            anchors.rightMargin: Theme.paddingMedium
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.highlightColor
            horizontalAlignment: Text.AlignRight
        }
    }*/

CoverActionList {
    //enabled: appSettings.lastPage !== 1
        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: appWindow.doFocusOnSearch()
        }
    }
    /*CoverActionList {
        enabled: appSettings.lastPage === 1
        iconBackground: true
        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: appWindow.eventModel.update()
        }
    }*/
}


