import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.folderlistmodel

Item {
    id: root

    implicitWidth: 200

    property int songindex: -1
    property int count: 0

    function clear() {
        songListModel.clear()
    }

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

    Frame {
        anchors.fill: parent
        padding: 15

        background: Rectangle {
            color: "lightgray"
            opacity: 0.7
        }

        ListView {
            id: playList
            visible: model.count > 0
            anchors.fill: parent
            displayMarginBeginning: 50

            ListModel{
                id: songListModel
            }

            Component {
                id: fileDelegate
                Item {
                    height: 28
                    Rectangle{
                        Text { text: model.name }
                    }
                }
            }

            model: songListModel
            delegate: fileDelegate
        }

        Text {
            id: metadataNoList
            visible: songListModel.count === 0
            text: qsTr("当前播放列表为空")
        }
    }
}
