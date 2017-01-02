import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0

Page {
    id: settingsPage
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-lidderbuch/settings"
        property int appLanguage
        property int fontSize
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: parent.width
            //spacing: Theme.paddingLarge

            PageHeader {
                //: Header of the settings page
                title: qsTr("Astellungen")
            }

            /*ComboBox {
                label: qsTr("Language")
                currentIndex: appSettings.appLanguage

                menu: ContextMenu {
                    MenuItem { text: qsTr("System") }
                    MenuItem { text: qsTr("L\u00ebtzebuergesch") }
                    MenuItem { text: qsTr("English") }
                    MenuItem { text: qsTr("Deutsch") }
                    MenuItem { text: qsTr("Francais") }
                    onActivated: appSettings.setValue("appLanguage", index)
                }
            }*/
            ComboBox {
                label: qsTr("Schrëftgréisst")
                currentIndex: appSettings.fontSize

                menu: ContextMenu {
                    MenuItem { text: qsTr("Kleng") }
                    MenuItem { text: qsTr("Mëttel") }
                    MenuItem { text: qsTr("Grouss") }
                    MenuItem { text: qsTr("Ech si voll") }
                    onActivated: appSettings.setValue("fontSize", index)
                }
            }
        }

        ScrollDecorator {  }
    }
}