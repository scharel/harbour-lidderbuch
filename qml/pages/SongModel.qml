import QtQuick 2.0

ListModel {
    property string file: dataLocation.path + "/songs.json"
    property string url: "https://acel.lu/api/v1/songs"
    property string json: ""
    property bool busy: false
    onJsonChanged: parseJson()

    function parseJson() {
        var songs = JSON.parse(json);
        if (songs.errors !== undefined) {
            console.log("Error fetching songs: " + songs.errors[0].message)
            json = ""
        }
        else {
            clear()
            append(songs)
        }
    }

    function update() {
        busy = true
        var apiReq = new XMLHttpRequest
        apiReq.open("GET", url)
        apiReq.onreadystatechange = function() {
            if (apiReq.readyState === XMLHttpRequest.DONE) {
                console.log("Loaded songs from api")
                json = apiReq.responseText
                var filePut = new XMLHttpRequest
                filePut.open("PUT", file)
                filePut.send(json)
                busy = false
            }
        }
        apiReq.send()
    }

    Component.onCompleted: {
        busy = true
        var fileReq = new XMLHttpRequest
        fileReq.open("GET", file)
        fileReq.onreadystatechange = function() {
            if (fileReq.readyState === XMLHttpRequest.DONE) {
                if (fileReq.responseText === "") {
                    update()
                }
                else {
                    console.log("Loaded songs from local file")
                    json = fileReq.responseText
                    busy = false
                }
            }
        }
        fileReq.send()
    }
}
