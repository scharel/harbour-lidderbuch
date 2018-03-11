import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import "pages"
import "cover"

ApplicationWindow
{
    id: appWindow
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-lidderbuch/settings"
        //: Alternative text if no update time is available
        property int fontSize: value("fontSize", 1)
        property int colorTheme: value("colorTheme", 0)
        property bool interactionHint: value("interactionHint", true)
        property bool eventsHint: value("eventsHint", true)
        property date songsUpdate: value("songsUpdate", new Date(0))
        property date eventsUpdate: value("eventsUpdate", new Date(0))
    }
    /*property var songModel: SongModel {
        onLastUpdateChanged: appSettings.setValue("lastUpdate", lastUpdate)
    }*/

    property var daysLux: ["Sonndeg", "Méindeg", "Dënschdeg", "Mëttwoch", "Donneschdeg", "Freideg", "Samschdeg"]
    property var monthsLux: ["Januar", "Februar", "Mäerz", "Abrëll", "Mee", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]

    property var songModel: JSONListModel {
        //id: eventModel
        url: "https://acel.lu/api/v2/songs"
        name: "songs"
        saveFile: true
    }
    Connections {
        target: songModel
        onLastUpdateChanged: appSettings.songsUpdate = songModel.lastUpdate
    }

    signal coverSearchTriggered()
    function doFocusOnSearch() {
        while (pageStack.depth > 1)
            pageStack.pop()
        pageStack.completeAnimation()
        activate()
        coverSearchTriggered()
    }

    initialPage: Component { SongsPage{ } }
    cover: Component { CoverPage{ } }
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
