import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

ListModel {
    property url url
    property string json
    property string name
    property string file: StandardPaths.data + "/" + name + ".json"
    property bool saveFile: false
    property bool busy: api.busy
    property int status: api.error
    property date lastUpdate: new Date(0)

    onJsonChanged: {
        if (saveFile) {
            var filePut = new XMLHttpRequest
            filePut.open("PUT", file)
            filePut.send(json)
        }
        refresh()
    }

    function setJson(_json) {
        json = _json
        lastUpdate = new Date()
    }

    function flush() {
        json = ""
        var filePut = new XMLHttpRequest
        filePut.open("PUT", file)
        filePut.send(json)
        clear()
        lastUpdate = new Date(0)
        status = 200
    }

    function refresh() {
        search("")
    }

    function search(query) {
        clear()
        var elements = parseJson()
        for (var element in elements) {
            elements[element].section = ""
            var match = false
            for (var child in elements[element]) {
                if (elements[element][child]) {
                    match = (elements[element][child].toString().toLowerCase().indexOf(query) >= 0) || match
                }
            }
            if (query === "" || match)
                append(elements[element])
        }
    }

    function parseJson() {
        var elements = JSON.parse(json)
        if (elements === null) {
            console.log("Error parsing " + name + "-JSON")
            elements = ""
            json = ""
            return null
        }
        else {
            clear()
            return elements
        }
    }

    function update() {
        console.log("Downloading " + url)
        api.get(url)
    }

    Component.onCompleted: {
        if (saveFile) {
            if (name === "") {
                saveFile = false
            }
            else {
                busy = true
                var fileReq = new XMLHttpRequest
                fileReq.open("GET", file)
                fileReq.onreadystatechange = function() {
                    if (fileReq.readyState === XMLHttpRequest.DONE) {
                        if (fileReq.responseText === "") {
                            update()
                        }
                        else {
                            console.log("Loaded " + name + " from local JSON file")
                            json = fileReq.responseText
                            busy = false
                        }
                    }
                }
                fileReq.send()
            }
        }
    }
}
