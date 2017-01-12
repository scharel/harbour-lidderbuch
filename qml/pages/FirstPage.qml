import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: songsPage
    function doFocusOnSearch() {
        console.log("Should focus now")
        searchField.forceActiveFocus()
    }

    SilicaListView {
        anchors.fill: parent

        PullDownMenu {
            busy: songModel.busy
            MenuItem {
                //: Pulldown menu item to About page
                text: qsTr("Iwwer d'App")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                //: Pulldown menu item to Settings page
                text: qsTr("Astellungen")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        header: PageHeader {
            //: Page Header
            //title: qsTr("ACEL Lidderbuch")
            SearchField {
                id: searchField
                width: parent.width
                //: Page Header
                placeholderText: qsTr("ACEL Lidderbuch")
                onTextChanged: {
                    songModel.search(text)
                }
                Connections {
                    target: appWindow
                    onFocusOnSearch: searchField.forceActiveFocus()
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
        }

        model: songModel
        currentIndex: -1

        delegate: ListItem {
            id: song
            width: parent.width
            height: Theme.itemSizeSmall
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SongPage.qml"), {song: model})
                pageStack.pushAttached(Qt.resolvedUrl("DetailsPage.qml"), {song: model})
            }

            Row {
                width: parent.width
                spacing: Theme.paddingMedium
                x: Theme.horizontalPageMargin
                anchors.verticalCenter: parent.verticalCenter
                Label {
                    id: songNumber
                    text: model.number
                    width: Theme.iconSizeSmall
                    color: song.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    opacity: model.number === 0 ? 0 : 1
                }

                Label {
                    id: songName
                    text: model.name
                    width: parent.width - songNumber.x - songNumber.width
                    truncationMode: TruncationMode.Fade
                    color: song.highlighted ? Theme.highlightColor : Theme.primaryColor
                }
            }
        }

        section.property: "category"
        section.criteria: ViewSection.FullString
        section.delegate: SectionHeader {
            text: section
        }

        VerticalScrollDecorator {}
    }
}
