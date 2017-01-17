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
        property string lastUpdate: value("lastUpdate", qsTr("nach ni"))
        property int fontSize: value("fontSize", 1)
        property int colorTheme: value("colorTheme", 0)
        property bool interactionHint: value("interactionHint", true)
    }
    property var songModel: SongModel {
        onLastUpdateChanged: appSettings.setValue("lastUpdate", lastUpdate)
    }
    signal coverSearchTriggered()
    function doFocusOnSearch() {
        while (pageStack.depth > 1)
            pageStack.pop()
        pageStack.completeAnimation()
        activate()
        coverSearchTriggered()
    }

    initialPage: Component { FirstPage{ } }
    cover: Component { CoverPage{ } }
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
