import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import harbour.lidderbuch 1.0
import "pages"
import "cover"

ApplicationWindow
{
    id: appWindow
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-lidderbuch/settings"
        property int fontSize: value("fontSize", 1)     // 0=Small; 1=Medium; 2=Large; 3=ExtraLarge
        property int colorTheme: value("colorTheme", 0) // 0=SailfishOS; 1=Dark; 2=BlackOnWhite; 4=Matrix
        property bool interactionHint: value("interactionHint", true)
        property bool songsHint: value("songsHint", true)
        property date songsUpdate: value("songsUpdate", new Date(0))
    }

    property var api: NetworkRequest { }

    property var songModel: JSONListModel {
        url: "https://acel.lu/songs.json"
        name: "songs"
        saveFile: true
    }
    Connections {
        target: songModel
        onLastUpdateChanged: appSettings.songsUpdate = songModel.lastUpdate
    }
    Connections {
        target: api
        onFinishedChanged: {
            if (api.finished && api.error === 0) {
                console.log("Successfully loaded " + songModel.url)
                songModel.setJson(api.data)
            }
        }
        onErrorChanged: {
            if (api.error !== 0) {
                console.log("Error loading " + songModel.url + " - " + api.errorString + " - (" + api.error + ")")
            }
        }
    }

    signal coverSearchTriggered()
    function doFocusOnSearch() {
        pageStack.clear()
        pageStack.push(songsPage)
        pageStack.completeAnimation()
        activate()
        coverSearchTriggered()
    }

    initialPage: Component { SongsPage { } }
    cover: Component { CoverPage{ } }

    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
