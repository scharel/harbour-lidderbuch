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

        property int activeLine: -1
        property int activeLineInParagraph: 0
        onActiveLineChanged: {
            //console.log("Active line: " + activeLine)

            if (activeLine < 0) { // reset the line focus
                activeLine = -1
                activeLineInParagraph = 0
                if (currentItem)
                    currentItem.highlightLine(-1)
                currentIndex = -1
            }
            else {              // set or change the line focus
                if (currentIndex < 0)
                    currentIndex = 0

                if (currentItem.highlightLine(activeLineInParagraph))
                    activeLineInParagraph++
                else {
                    currentItem.highlightLine(-1)
                    currentIndex++
                    activeLineInParagraph = 0
                    if (currentItem) {
                        if (currentItem.highlightLine(activeLineInParagraph))
                            activeLineInParagraph++
                    }
                    else {
                        activeLine = -1
                    }
                }
            }
        }

        currentIndex: -1
        highlightFollowsCurrentItem: true
        focus: true

        PullDownMenu {
            visible: listView.activeLine >= 0
            MenuItem {
                //: Pulldown menu item to clear the line focus
                text: qsTr("Zeilenfokus zerécksetzen")
                onClicked: listView.activeLine = -1
            }
        }

        header: PageHeader {
            title: song.name
        }

        model: song.paragraphs

        delegate: Rectangle {
            id: delegateItem
            color: songsPage.bgColor

            width: parent.width
            height: content.height + Theme.paddingLarge

            TextEdit {
                id: content
                readOnly: true
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                anchors.verticalCenter: parent.verticalCenter
                color: songsPage.fontColor
                selectionColor: songsPage.fontColor
                selectedTextColor: Qt.colorEqual(songsPage.bgColor, "transparent") ? "black" : songsPage.bgColor
                font.family: Theme.fontFamily
                font.pixelSize: songsPage.fontSize
                font.italic: model.type === "refrain"
                wrapMode: Text.Wrap
                text: model.content
            }
            MouseArea {
                anchors.fill: parent
                onClicked: listView.activeLine++
            }
            function highlightLine(line) {
                if (line < 0) {
                    content.deselect()
                    return true
                }
                else {
                    var currentLine = 0
                    var currentNewLine = 0
                    var lastNewline = 0
                    while (currentLine <= line && lastNewline >= 0) {
                        lastNewline = currentNewLine
                        currentNewLine = content.text.indexOf('\n', lastNewline + 1)
                        currentLine++
                    }
                    if (currentNewLine >= 0 && lastNewline >= 0) {
                        content.select(lastNewline, currentNewLine)
                        return true
                    }
                    else if (currentNewLine < 0) {
                        content.select(lastNewline, content.length)
                        return true
                    }
                    else {
                        return false
                    }
                }
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

    TouchInteractionHint {
        id: hint
        Component.onCompleted: if (appSettings.interactionHint) restart()
        interactionMode: TouchInteraction.Swipe
        direction: TouchInteraction.Left
    }
    InteractionHintLabel {
        //: Show further details about the song
        text: qsTr("Weider Detailer iwwer d'Lidd uweisen")
        opacity: hint.running ? 1.0 : 0.0
        Behavior on opacity { FadeAnimation {} }
        width: parent.width
        height: parent.height
    }
}
