import QtQuick 2.0
import Sailfish.Silica 1.0

ListModel {
    property string file: StandardPaths.data + "/songs.json"
    property string url: "https://acel.lu/api/v1/songs"
    property string json: ""
    property bool busy: false
    property var lastUpdate

    onJsonChanged: refresh()

    function refresh() {
        search("")
    }

    function search(query) {
        clear()
        //console.log("Search: " + query)
        var songs = parseJson()
        for (var i=0; i<songs.length; i++) {
            var numberIndex = songs[i].number? songs[i].number.toString().indexOf(query): -1
            var nameIndex = songs[i].name? songs[i].name.toLowerCase().indexOf(query.toLowerCase()): -1
            var categoryIndex = songs[i].category? songs[i].category.toLowerCase().indexOf(query.toLowerCase()): -1
            var lyricsAuthorIndex = songs[i].lyrics_author? songs[i].lyrics_author.toLowerCase().indexOf(query.toLowerCase()): -1
            var melodyAuthorIndex = songs[i].melody_author? songs[i].melody_author.toLowerCase().indexOf(query.toLowerCase()): -1
            if (query === "" || numberIndex >= 0 || nameIndex >= 0 || categoryIndex >= 0 || lyricsAuthorIndex >= 0 || melodyAuthorIndex >= 0) {
                append(songs[i])
            }
        }
    }

    function parseJson() {
        var songs = JSON.parse(json);
        if (songs.errors !== undefined) {
            console.log("Error fetching songs: " + songs.errors[0].message)
            json = ""
            return null
        }
        else {
            clear()
            return songs
        }
    }

    function update() {
        busy = true
        var apiReq = new XMLHttpRequest
        apiReq.open("GET", url)
        apiReq.onreadystatechange = function() {
            if (apiReq.readyState === XMLHttpRequest.DONE) {
                if (apiReq.status === 200) {
                    console.log("Loaded songs from api")
                    json = apiReq.responseText
                    var filePut = new XMLHttpRequest
                    filePut.open("PUT", file)
                    filePut.send(json)
                    lastUpdate = new Date().toLocaleString(Qt.locale("de_LU"), "dd.MM.yyyy h:mm")
                }
                else {
                    console.log("Error loading songs from api")
                }

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
