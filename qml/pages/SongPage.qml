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
                if (currentIndex < 0)   // if no line focus was set before
                    currentIndex = 0

                if (currentItem.highlightLine(activeLineInParagraph))   // highlight the line in the paragraph
                    activeLineInParagraph++
                else {  // if the end of the paragraph is reached
                    currentItem.highlightLine(-1)
                    currentIndex++
                    activeLineInParagraph = 0
                    if (currentItem) {  // if there is another paragraph following
                        if (currentItem.highlightLine(activeLineInParagraph))
                            activeLineInParagraph++
                    }   // if the end of the song is reached
                    else {
                        activeLine = -1
                        scrollToTop()
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
                if (line < 0) {         // unselect everything
                    content.deselect()
                    return true
                }
                else {                      // select line
                    var currentLine = 0     // iterator through the lines
                    var currentNewLine = 0  // position of the end of the current line
                    var lastNewline = 0     // postition of the end of the previous line (aka beginning of the current line)
                    while (currentLine <= line && currentNewLine >= 0) {   // iterate until the target line or the end of the paragraph is reached
                        lastNewline = currentNewLine
                        currentNewLine = content.text.indexOf('\n', lastNewline + 1)    // find the end of the line (-1 if not new line available)
                        currentLine++
                    }
                    if (currentNewLine > 0) {
                        content.select(lastNewline, currentNewLine)
                        return true
                    }
                    else if (currentLine > line) {
                        content.select(lastNewline, content.length)
                        return true
                    }
                    else {
                        return false
                    }
                }
            }
        }

        MouseArea { // fill the remaining background
            width: parent.width
            height: songsPage.height - listView.contentHeight
            anchors.bottom: parent.bottom
            Rectangle {
                anchors.fill: parent
                color: songsPage.bgColor
            }
            onClicked: listView.activeLine++
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
