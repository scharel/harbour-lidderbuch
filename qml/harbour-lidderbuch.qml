import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import "pages"
import "cover"

ApplicationWindow
{
    id: appWindow
    property var appSettings: ConfigurationGroup {
        path: "/apps/harbour-lidderbuch/settings"
        property string lastUpdate
        property int fontSize
    }
    property var songModel: SongModel {
        onLastUpdateChanged: appSettings.setValue("lastUpdate", lastUpdate)
    }
    signal focusOnSearch(bool focus)
    function doFocusOnSearch() {
        while (pageStack.depth > 1)
            pageStack.pop()
        activate()
        pageStack.completeAnimation()
        focusOnSearch(true)
    }

    initialPage: Component { FirstPage{ } }
    cover: Component { CoverPage{ } }
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
