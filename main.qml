import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Music Player")
    property alias source: mediaPlayer.source

    Popup {
        id: mediaError
        anchors.centerIn: Overlay.overlay
        Text {
            id: mediaErrorText
        }
    }

    Image {
        id: cover
        source: "qrc:///Cover.jpg"
        anchors.top: parent.top
        anchors.topMargin: root.height/4
        anchors.right: playList.visible ? playList.left : parent.right
        anchors.rightMargin: playList.visible ? (root.width - playList.width)/2 - root.height/4 : root.width/2 - root.height/4
        height: root.height/2
        fillMode: Image.PreserveAspectFit
        asynchronous : true
    }

    MediaPlayer {
        id: mediaPlayer

        property url folderUrl

        function updateMetadata() {
            metadataInfo.clear();
            metadataInfo.read(mediaPlayer.metaData);
            metadataInfo.read(mediaPlayer.audioTracks[mediaPlayer.activeAudioTrack]);
        }

        audioOutput: AudioOutput {
            id: audio
            muted: playbackControl.muted
            volume: playbackControl.volume
        }

        onErrorOccurred: { mediaErrorText.text = mediaPlayer.errorString; mediaError.open() }
        onMetaDataChanged: { updateMetadata() }
        onTracksChanged: {
            audioTracksInfo.read(mediaPlayer.audioTracks);
            audioTracksInfo.selectedTrack = mediaPlayer.activeAudioTrack;
            subtitleTracksInfo.read(mediaPlayer.subtitleTracks);
            subtitleTracksInfo.selectedTrack = mediaPlayer.activeSubtitleTrack;
            updateMetadata()
        }
        onActiveTracksChanged: { updateMetadata() }
    }

    PlayerMenuBar {
        id: menuBar

        anchors.left: parent.left
        anchors.right: parent.right

        mediaPlayer: mediaPlayer
        metadataInfo: metadataInfo
        audioTracksInfo: audioTracksInfo

        onClosePlayer: root.close()
    }

    TracksInfo {
        id: audioTracksInfo

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom

        visible: false
        onSelectedTrackChanged:  mediaPlayer.activeAudioTrack = audioTracksInfo.selectedTrack
    }

    TracksInfo {
        id: subtitleTracksInfo

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom

        visible: false
        onSelectedTrackChanged: mediaPlayer.activeSubtitleTrack = subtitleTracksInfo.selectedTrack
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
        anchors.top: parent.top
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom

        visible: false
    }


    PlaybackControl {
        id: playbackControl

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        mediaPlayer: mediaPlayer
    }
}
