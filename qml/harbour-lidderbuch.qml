import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

ApplicationWindow
{
    id: appWindow
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-lidderbuch/settings"
        property var startPage: value("startPage", 0 )  // 0=SongsPage; 1=EventsPage; 2=LastPage
        property int lastPage: value("lastPage", 0)     // 0=SongsPage; 1=EventsPage
        property int fontSize: value("fontSize", 1)     // 0=Small; 1=Medium; 2=Large; 3=ExtraLarge
        property int colorTheme: value("colorTheme", 0) // 0=SailfishOS; 1=Dark; 2=BlackOnWhite; 4=Matrix
        property bool interactionHint: value("interactionHint", true)
        property bool eventsHint: value("eventsHint", true)
        property bool songsHint: value("songsHint", true)
        //property bool alternativeAPI: value("alternativeAPI", false) //obsolete
        property date songsUpdate: value("songsUpdate", new Date(0))
        property date eventsUpdate: value("eventsUpdate", new Date(0))
    }

    //property var daysLux: ["Sonndeg", "Méindeg", "Dënschdeg", "Mëttwoch", "Donneschdeg", "Freideg", "Samschdeg"]
    //property var monthsLux: ["Januar", "Februar", "Mäerz", "Abrëll", "Mee", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]

    property var songModel: JSONListModel {
        url: "https://acel.lu/songs.json"
        name: "songs"
        saveFile: true
    }
    Connections {
        target: songModel
        onLastUpdateChanged: appSettings.songsUpdate = songModel.lastUpdate
    }

    /*property var eventModel: JSONListModel {
        url: appSettings.alternativeAPI ? "https://www.scharel.name/harbour/lidderbuch/events" : "https://acel.lu/api/v1/events"
        name: "events"
        saveFile: true
    }
    Connections {
        target: eventModel
        onLastUpdateChanged: appSettings.eventsUpdate = eventModel.lastUpdate
    }*/

    signal coverSearchTriggered()
    function doFocusOnSearch() {
        pageStack.clear()
        pageStack.push(songsPage)
        pageStack.completeAnimation()
        activate()
        coverSearchTriggered()
    }

    Component {
        id: songsPage
        SongsPage { }
    }
    /*Component {
        id: eventsPage
        EventsPage { }
    }
    initialPage: appSettings.startPage === 2 ? (appSettings.lastPage === 1 ? eventsPage : songsPage) :
                                               (appSettings.startPage === 1 ? eventsPage : songsPage)
    */
    initialPage: songsPage

    cover: Component { CoverPage{ } }
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
