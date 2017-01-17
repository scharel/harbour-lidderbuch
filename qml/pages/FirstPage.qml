import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: firstPage
    Component.onCompleted: console.log(StandardPaths.data)

    SilicaListView {
        id: listView
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

        Component {
            id: searchComponent

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
                    onCoverSearchTriggered: searchField.forceActiveFocus()
                }
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
        }

        header: searchComponent

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
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                spacing: Theme.paddingMedium
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

        ViewPlaceholder {
            verticalOffset: -2 * Theme.paddingLarge
            enabled: songModel.count === 0 && searchField.text !== ""
            //: No songs found with search function
            text: qsTr("Keng Lidder fonnt!")
            //: Try another search query
            hintText: qsTr("Probéier eng aner Sich.")
        }

        ViewPlaceholder {
            enabled: songModel.count === 0 && searchField.text === ""
            //: No songs available
            text: qsTr("Keng Lidder verfügbar!")
            //: Use the settings page to download content
            hintText: qsTr("An den Astellungen kennen d'Lidder nei erofgeluede ginn.")
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
