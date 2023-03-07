import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer
    required property MetadataInfo metadataInfo
    required property TracksInfo audioTracksInfo

    height: menuBar.height

    signal closePlayer

    function closeOverlays(){
        metadataInfo.visible = false;
        audioTracksInfo.visible = false;
        subtitleTracksInfo.visible = false;
    }

    function showOverlay(overlay){
        closeOverlays();
        overlay.visible = true;
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        nameFilters: ["FLAC files (*.flac)", "MP3 files (*.mp3)"]
        onAccepted: {
            mediaPlayer.stop()
            mediaPlayer.source = fileDialog.selectedFile
            var str = source.toString()
            var str2 = fileDialog.currentFolder.toString()
            var filename = str.substring(0, str.lastIndexOf("."))
            filename = filename.substring(str2.length + 1)
            playList.addSong(filename, str)
            playList.setCurrentSong(playList.count - 1)
            mediaPlayer.play()
        }
    }

    FolderDialog {
        id: folderDialog
        title: "Please choose a Folder"
        onAccepted: {
            mediaPlayer.folderUrl = folderDialog.selectedFolder
        }
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: qsTr("&File")
            Action {
                text: qsTr("&Open")
                onTriggered: fileDialog.open()
            }

            Action {
                text: qsTr("&OpenFolder")
                onTriggered: folderDialog.open()
            }

            Action {
                text: qsTr("&Exit");
                onTriggered: closePlayer()
            }
        }

        Menu {
            title: qsTr("&View")
            Action {
                text: qsTr("Metadata")
                onTriggered: showOverlay(metadataInfo)
            }
            Action {
                text: qsTr("PlayList")
                onTriggered: showOverlay(playList)
            }
        }

        Menu {
            title: qsTr("&Tracks")
            Action {
                text: qsTr("Audio")
                onTriggered: showOverlay(audioTracksInfo)
            }
            Action {
                text: qsTr("Subtitles")
                onTriggered: showOverlay(subtitleTracksInfo)
            }
        }
    }
}
