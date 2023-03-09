import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer
    required property MetadataInfo metadataInfo

    height: menuBar.height

    signal closePlayer

    function closeOverlays(){
        metadataInfo.visible = false;
        playList.visible = false;
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
            playList.songFolder = folderDialog.selectedFolder
        }
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: "File"
            Action {
                text: "Open"
                onTriggered: fileDialog.open()
            }

            Action {
                text: "OpenFolder"
                onTriggered: folderDialog.open()
            }

            Action {
                text: "Exit"
                onTriggered: closePlayer()
            }
        }

        Menu {
            title: "View"
            Action {
                text: "Metadata"
                onTriggered: {
                    if(!metadataInfo.visible)
                        showOverlay(metadataInfo)
                    else
                        metadataInfo.visible = false
                }
            }
            Action {
                text: "PlayList"
                onTriggered: showOverlay(playList)
            }
        }
    }
}
