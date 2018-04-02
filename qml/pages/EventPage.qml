import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

Page {
    property var event
    property var start_date: new Date(event.start_time*1000)
    property var stop_date: new Date(event.end_time*1000)

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        bottomMargin: Theme.horizontalPageMargin

        PullDownMenu {
            MenuItem {
                //: Pulldown menu item to visit the event website
                text: qsTr("Websäit opmaachen")
                onClicked: Qt.openUrlExternally(event.url)
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                title: event.name
                description: daysLux[start_date.getDay()] + ", " +  start_date.toLocaleString(Qt.locale(), "d. ") + monthsLux[start_date.getMonth()] + " " + start_date.getFullYear() +
                             ((start_date.getDate() !== stop_date.getDate()) ?
                                 "\nbis " +
                                 daysLux[stop_date.getDay()] + ", " +  stop_date.toLocaleString(Qt.locale(), "d. ") + monthsLux[stop_date.getMonth()] + " " + stop_date.getFullYear() :
                                 "")
            }

            SectionHeader {
                //: time
                text: qsTr("Zäit")
            }
            Row {
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                visible: start_date.valueOf() !== stop_date.valueOf()
                Label {
                    x: Theme.horizontalPageMargin
                    color: Theme.highlightColor
                    text: start_date.toLocaleTimeString(Qt.locale(), "h:mm")
                }
                Label {
                    x: Theme.horizontalPageMargin
                    color: Theme.secondaryHighlightColor
                    //: until
                    text: " " + qsTr("bis") + " "
                }
                Label {
                    x: Theme.horizontalPageMargin
                    color: Theme.highlightColor
                    text: stop_date.toLocaleTimeString(Qt.locale(), "h:mm")
                }
                Label {
                    x: Theme.horizontalPageMargin
                    color: Theme.secondaryHighlightColor
                    //: o'clock
                    text: " " + qsTr("Auer")
                }
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: event.ics_url.length > 0
                enabled: !appSettings.alternativeAPI
                //: Import the event into the calendar
                text: qsTr("An de Kalenner importéieren")
                DBusInterface {
                    id: calendarImport
                    service: 'com.jolla.calendar.ui'
                    path: '/com/jolla/calendar/ui'
                    iface: 'com.jolla.calendar.ui'
                }
                onClicked: {
                    var icsDownload = new XMLHttpRequest
                    icsDownload.open("GET", event.ics_url, true)
                    icsDownload.setRequestHeader('User-Agent', 'SailfishOS/harbour-lidderbuch')
                    icsDownload.onreadystatechange = function() {
                        if (icsDownload.readyState === XMLHttpRequest.DONE) {
                            if (icsDownload.status === 200) {
                                console.log("Successfully loaded " + event.ics_url)
                                var filePut = new XMLHttpRequest
                                filePut.open("PUT", StandardPaths.data + "/event.ics")
                                filePut.onreadystatechange = function() {
                                    if (filePut.readyState === XMLHttpRequest.DONE)
                                        calendarImport.call('importFile', StandardPaths.data + "/event.ics")
                                }
                                filePut.send(icsDownload.responseText)
                            }
                        }
                    }
                    icsDownload.send()
                }
            }

            SectionHeader {
                visible: eventLocationNameLabel.visible || eventLocationAddressLabel.visible
                //: location
                text: qsTr("Locatioun")
            }
            Label {
                id: eventLocationNameLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                visible: event.location !== null && event.location !== undefined && text.length > 0
                color: Theme.highlightColor
                linkColor: Theme.primaryColor
                onLinkActivated: Qt.openUrlExternally(link)
                text: event.location !== null && event.location !== undefined ? event.location.name : ""
                Component.onCompleted: {
                    if (event.location !== null && event.location !== undefined)
                        if (event.location.url !== null && event.location.url !== undefined)
                            text = "<a href=\"" + event.location.url + "\">" + text + "</a>"
                }
            }
            Label {
                id: eventLocationAddressLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                visible: event.location !== null && event.location !== undefined && text.length > 0
                color: Theme.highlightColor
                text: event.location !== null && event.location !== undefined ?
                    (event.location.address !== null && event.location.address !== undefined ? event.location.address : "")
                    + (event.location.post_code !== null && event.location.post_code !== undefined ? "\n" + event.location.post_code + ", " : "")
                    + (event.location.locality !== null && event.location.locality !== undefined ? event.location.locality : "")
                    + (event.location.country !== null && event.location.country !== undefined ? "\n" + event.location.country : "") : ""
            }

            SectionHeader {
                visible: eventDescriptionLabel.visible
                //: description
                text: qsTr("Beschreiwung")
            }
            Text {
                id: eventDescriptionLabel
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                visible: text.length > 0
                font.pixelSize: Theme.fontSizeSmall
                font.family: Theme.fontFamily
                textFormat: Text.RichText
                color: Theme.highlightColor
                linkColor: Theme.primaryColor
                onLinkActivated: Qt.openUrlExternally(link)
                wrapMode: Text.Wrap
                text: event.description !== null && event.description !== undefined ? event.description : ""
                Component.onCompleted: {
                    var nth = 0
                    text = text.replace(/\n/g, "<br>")
                    text = text.replace(/\*\*/g, function(match, i, original) {
                        nth++; return (nth % 2) ? "<b>" : "</b>"; } )
                }
            }

            SectionHeader {
                visible: eventOrganizersList.count > 0
                //: organizers
                text: qsTr("Organisateuren")
            }
            Repeater {
                id: eventOrganizersList
                //visible: event.organizers.length > 0
                model: event.organizers

                delegate:  ListItem {
                    id: organizer
                    width: parent.width
                    contentHeight: organizerRow.height
                    Row {
                        id: organizerRow
                        x: Theme.horizontalPageMargin
                        width: parent.width
                        height: Math.max(logo.height, organizerLabel.height)
                        spacing: Theme.paddingMedium
                        Item {
                            width: Theme.itemSizeExtraLarge
                            height: 1
                            anchors.verticalCenter: parent.verticalCenter
                            visible: logo.status !== Image.Error
                            Image {
                                id: logo
                                width: parent.width
                                sourceSize.width: width
                                source: logo_file_url_bitmap
                                anchors.centerIn: parent
                                fillMode: Image.PreserveAspectFit
                                BusyIndicator {
                                    size: BusyIndicatorSize.Medium
                                    anchors.centerIn: logo
                                    running: logo.status === Image.Loading
                                }
                            }
                        }
                        Label {
                            id: organizerLabel
                            width: parent.width - x - Theme.horizontalPageMargin
                            anchors.verticalCenter: parent.verticalCenter
                            color: organizer.highlighted ? Theme.highlightColor : Theme.primaryColor
                            wrapMode: Text.Wrap
                            text: short_name + "\n" + name
                        }
                    }
                    menu: ContextMenu {
                        MenuItem {
                            //: Visit the organizers website on acel.lu
                            text: short_name + " " + qsTr("op acel.lu")
                            onClicked: Qt.openUrlExternally(url)
                        }
                        MenuItem {
                            //: Visit the organizers website
                            text: short_name + " " + qsTr("Websäit")
                            onClicked: Qt.openUrlExternally(website_url)
                        }
                        MenuItem {
                            //: Visit the organizers social network page
                            text: qsTr("Facebook")
                            onClicked: Qt.openUrlExternally(social_network_url)
                        }
                    }
                    showMenuOnPressAndHold: false
                    onClicked: showMenu()
                }
            }

            VerticalScrollDecorator { flickable: flickable }
        }
    }
}
