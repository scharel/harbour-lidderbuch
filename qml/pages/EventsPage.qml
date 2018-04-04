import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: eventsPage

    onStatusChanged: if (status === PageStatus.Active) appSettings.setValue("eventsHint", false)

    SilicaListView {
        id: listView
        anchors.fill: parent
        //spacing: Theme.paddingMedium

        PullDownMenu {
            busy: eventModel.busy
            /*MenuItem {
                //: Pulldown menu item to selcet event categories
                text: qsTr("Kategorien")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("CategoriesDialog.qml"))
                    dialog.accepted.connect(function() {
                        console.log(dialog.name)
                    })

                }
            }*/
            MenuItem {
                //: Pulldown menu item to update the events
                text: qsTr("Aktualiséieren") + (eventModel.busy ? "..." : "")
                enabled: !eventModel.busy
                onClicked: eventModel.update()
            }
            MenuLabel {
                Timer { id: errorTimer; interval: 2000; onTriggered: eventModel.status = 200 }
                Connections { target: eventModel; onStatusChanged: eventModel.status === 200 ? errorTimer.stop() : errorTimer.restart() }
                text: (errorTimer.running ?
                          //: Error               //: Status
                          qsTr("Feeler") + " (" + qsTr("Status") + " " + eventModel.status + ")" :
                          //: Updated
                          qsTr("Aktualiséiert") + ": " +
                          (appSettings.eventsUpdate.valueOf() === 0 ?
                              //: never
                              qsTr("nach ni") :
                              appSettings.eventsUpdate.toLocaleString(Qt.locale(), Locale.ShortFormat)))
            }
        }

        header: PageHeader {
            //: Header of the events page
            title: qsTr("ACEL Agenda")
        }

        model: JSONListModel {
            id: eventModel
            url: appSettings.alternativeAPI ? "https://www.scharel.name/harbour/lidderbuch/events" : "https://acel.lu/api/v1/events"
            name: "events"
            saveFile: true
        }
        Connections {
            target: eventModel
            onLastUpdateChanged: appSettings.eventsUpdate = eventModel.lastUpdate
        }

        Component.onCompleted: eventModel.update()

        currentIndex: -1

        delegate: ListItem {
            id: event
            width: parent.width
            contentHeight: Theme.itemSizeExtraLarge
            Component.onCompleted: eventModel.setProperty(index, "section", monthsLux[new Date(start_time*1000).getMonth()] + " " + new Date(start_time*1000).getFullYear())

            onClicked: pageStack.push(Qt.resolvedUrl("EventPage.qml"), {event: model})

            Row {
                x: Theme.horizontalPageMargin
                width: parent.width - x
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingLarge
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Theme.paddingSmall
                    Rectangle {
                        width: Theme.iconSizeLarge
                        height: Theme.iconSizeExtraSmall
                        color: event.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Rectangle {
                        width: Theme.iconSizeLarge
                        height: Theme.iconSizeMedium
                        color: event.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                        Label {
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: new Date(start_time*1000).getDate()
                            font.pixelSize: Theme.fontSizeExtraLarge
                            font.bold: true
                            color: Theme.highlightColor //event.highlighted ? Theme.highlightColor : Theme.primaryColor
                        }
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - x
                    Label {
                        width: parent.width
                        text: name
                        truncationMode: TruncationMode.Fade
                        color: event.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    Row {
                        spacing: Theme.paddingSmall
                        visible: location === undefined ? false : location.name !== undefined
                        Image {
                            width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://theme/icon-m-location?"
                                    + (event.highlighted ? Theme.highlightColor : Theme.primaryColor)
                        }
                        Label {
                            id: locationLabel
                            color: event.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                            font.pixelSize: Theme.fontSizeSmall
                            Component.onCompleted: text = visible ? location.name : ""
                        }
                    }
                    Row {
                        spacing: Theme.paddingSmall
                        Image {
                            //width: Theme.iconSizeSmall; height: Theme.iconSizeSmall
                            anchors.verticalCenter: parent.verticalCenter
                            source: "image://theme/icon-s-invitation?"
                                    + (event.highlighted ? Theme.highlightColor : Theme.primaryColor)
                        }
                        Repeater {
                            id: organizersRepeater
                            model: organizers
                            Label {
                                color: event.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                                font.pixelSize: Theme.fontSizeSmall
                                text: short_name + (index < organizersRepeater.count-1 ? "," : "")
                            }
                        }
                    }
                }
            }
        }

        section.property: "section"
        section.delegate: SectionHeader {
            text: section
        }

        ViewPlaceholder {
            enabled: eventModel.count === 0 && !eventModel.busy
            //: No envent available
            text: qsTr("Näischt an der Agenda")
            //: Pull down to update the content
            hintText: qsTr("Erof zéien vir ze Aktualiséieren")
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: eventModel.count === 0 && eventModel.busy
        }

        VerticalScrollDecorator { flickable: listView }
    }
}
