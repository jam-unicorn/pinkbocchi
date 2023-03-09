import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: "Music Player"
    property alias source: mediaPlayer.source

    color: "white"

    Popup {
        id: mediaError
        anchors.centerIn: Overlay.overlay
        Text {
            id: mediaErrorText
        }
    }

    Image {
        id: cover
        source: "qrc:/resources/Cover.jpg"
        anchors.top: parent.top
        anchors.topMargin: root.height/4
        anchors.right: {
            if(metadataInfo.visible||playList.visible){
                return playList.left
            }
            else
                return parent.right
        }
        anchors.rightMargin: {
            if(metadataInfo.visible||playList.visible){
                return (root.width - metadataInfo.width)/2 - root.height/4
            }
            else
                return root.width/2 - root.height/4
        }
        height: root.height/2
        fillMode: Image.PreserveAspectFit
        asynchronous : true
    }

    MediaPlayer {
        id: mediaPlayer

        function updateMetadata() {
            metadataInfo.clear();
            metadataInfo.read(mediaPlayer.metaData);
        }

        audioOutput: AudioOutput {
            id: audio
            muted: playbackControl.muted
            volume: playbackControl.volume
        }

        onMediaStatusChanged: {
            if(mediaStatus == MediaPlayer.EndOfMedia){
                playList.nextSong()
            }
        }

        onErrorOccurred: { mediaErrorText.text = mediaPlayer.errorString; mediaError.open() }
        onMetaDataChanged: { updateMetadata() }
    }

    MetadataInfo {
        id: metadataInfo

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom

        visible: false
    }

    PlayList {
        id: playList

        anchors.right: parent.right
        anchors.top: menuBar.bottom
        anchors.bottom: playbackControl.opacity ? playbackControl.top : parent.bottom

        visible: false
    }

    PlaybackControl {
        id: playbackControl

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        mediaPlayer: mediaPlayer
    }

    PlayerMenuBar {
        id: menuBar

        anchors.left: parent.left
        anchors.right: parent.right

        mediaPlayer: mediaPlayer
        metadataInfo: metadataInfo

        onClosePlayer: root.close()
    }
}
