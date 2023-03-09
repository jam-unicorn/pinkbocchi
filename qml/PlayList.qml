import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.folderlistmodel

Item {
    id: root

    implicitWidth: 200

    property url songFolder: " "
    property int songindex: -1
    property int count: 0

    function getCurrentSong(){
        return songListModel.get(songindex).value
    }

    function getCurrentSongName(){
        return songListModel.get(songindex).name
    }

    function setCurrentSong(index){
        songindex = index
    }

    function addSong(str1, str2){
        count = count + 1
        songListModel.append(
                    {name:str1, value: str2, index: count - 1})
    }

    function previousSong(){
        mediaPlayer.stop()
        if(songindex===0){
            setCurrentSong(count - 1)
            mediaPlayer.source = getCurrentSong()
        }
        else{
            setCurrentSong(songindex - 1)
            mediaPlayer.source = getCurrentSong()
        }
        mediaPlayer.play()
    }

    function nextSong(){
        mediaPlayer.stop()
        if(songindex===count -1){
            setCurrentSong(0)
            mediaPlayer.source = getCurrentSong()
        }
        else{
            setCurrentSong(songindex + 1)
            mediaPlayer.source = getCurrentSong()
        }
        mediaPlayer.play()
    }

    Frame {
        anchors.fill: parent
        padding: 15

        background: Rectangle {
            color: "lightgrey"
            opacity: 0.5
        }

        ListView {
            id: playList
            visible: model.count > 0
            anchors.fill: parent

            ListModel{
                id: songListModel
            }

            Component {
                id: fileDelegate
                Button {
                    height: 28
                    flat: true
                    text: model.name
                    background: Rectangle {
                        color: "steelblue"
                        opacity: 0
                    }

                    ToolTip{
                        visible: pressed
                        text: model.name
                    }

                    onDoubleClicked: {
                        mediaPlayer.stop()
                        mediaPlayer.source = model.value
                        songindex = model.index
                        mediaPlayer.play()
                    }
                }
            }

            model: songListModel
            delegate: fileDelegate
        }

        Text {
            id: metadataNoList
            visible: songListModel.count === 0
            text: "no playlist present"
        }
    }

    ListView {
        id: folderView
        visible: false
        anchors.fill: parent

        FolderListModel{
            id: folderListModel
            folder:songFolder
            showDirs: false
            nameFilters: [ "*.flac", "*.mp3" ]
        }

        Component {
            id: folderDelegate

            Text{
                text:{
                    fileName
                }
                onTextChanged: {
                    var str = fileName.toString()
                    str = str.substring(0, str.lastIndexOf("."))
                    addSong(str, fileUrl.toString())
                }
            }
        }

        model: folderListModel
        delegate: folderDelegate
    }
}
