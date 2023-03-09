import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer
    property int mediaPlayerState: mediaPlayer.playbackState
    property alias muted: audio.muted
    property alias volume: audio.volume

    height: frame.height

    opacity: 1

    Behavior on opacity {NumberAnimation { duration: 300 }}

    function updateOpacity() {
        if (Qt.platform.os === "android" || Qt.platform.os === "ios")
            return;

        if (playbackControlHoover.hovered || mediaPlayerState != MediaPlayer.PlayingState || !mediaPlayer.hasVideo)
            root.opacity = 1;
        else
            root.opacity = 1;
    }

    function isChange(){
        if(playList.visible===true)
            playList.visible=false
        else
            playList.visible=true
    }

    Connections {
        target: mediaPlayer
        function onPlaybackStateChanged() { updateOpacity() }
    }

    HoverHandler {
        id: playbackControlHoover
        margin: 50
        onHoveredChanged: updateOpacity()
    }

    Frame {
        id: frame
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        background: Rectangle {
            color: "lightgrey"
        }

        ColumnLayout {
            id: playbackControlPanel
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            PlaybackSeekControl {
                Layout.fillWidth: true
                mediaPlayer: root.mediaPlayer
            }

            RowLayout {
                id: playerButtons
                Layout.fillWidth: true

                Item {
                    Layout.fillWidth: true
                }

                Text {
                    id: songName
                    Layout.alignment:Qt.AlignLeft
                    text: (playList.songindex === -1) ?  "" : playList.getCurrentSongName()
                }

                RowLayout {
                    Layout.alignment: Qt.AlignCenter
                    id: controlButtons

                    RoundButton {
                        id: loopButton
                        radius: 50.0
                        icon.source: (mediaPlayer.loops !== 1) ? "qrc:/resources/Loop.svg" : "qrc:/resources/Order.svg"
                        onClicked: {
                            if(mediaPlayer.loops === 1)
                                mediaPlayer.loops = 100
                            else
                                mediaPlayer.loops = 1
                        }
                    }

                    RoundButton {
                        id: previousButton
                        radius: 50.0
                        icon.source: "qrc:/resources/Previous.svg"
                        onClicked: {
                            mediaPlayer.stop()
                            playList.previousSong()
                        }
                    }

                    RoundButton {
                        id: pauseButton
                        radius: 50.0
                        icon.source: "qrc:/resources/Pause.svg"
                        onClicked: mediaPlayer.pause()
                    }

                    RoundButton {
                        id: playButton
                        radius: 50.0
                        icon.source: "qrc:/resources/Play.svg"
                        onClicked: mediaPlayer.play()
                    }

                    RoundButton {
                        id: nextButton
                        radius: 50.0
                        icon.source: "qrc:/resources/Next.svg"
                        onClicked: {
                            playList.nextSong()
                        }
                    }

                    RoundButton {
                        id: stopButton
                        radius: 50.0
                        icon.source: "qrc:/resources/Stop.svg"
                        onClicked: {mediaPlayer.stop()}
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                AudioControl {
                    id: audio
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 150
                    Layout.fillWidth: true
                    mediaPlayer: root.mediaPlayer
                }

                RoundButton {
                    id: displaySongList
                    radius: 50.0
                    icon.source: "qrc:/resources/PlayList.svg"
                    onClicked:isChange()
                }
            }
        }
    }

    states: [
        State {
            name: "playing"
            when: mediaPlayerState == MediaPlayer.PlayingState
            PropertyChanges { target: pauseButton; visible: true}
            PropertyChanges { target: playButton; visible: false}
            PropertyChanges { target: stopButton; visible: true}
        },
        State {
            name: "stopped"
            when: mediaPlayerState == MediaPlayer.StoppedState
            PropertyChanges { target: pauseButton; visible: false}
            PropertyChanges { target: playButton; visible: true}
            PropertyChanges { target: stopButton; visible: false}
        },
        State {
            name: "paused"
            when: mediaPlayerState == MediaPlayer.PausedState
            PropertyChanges { target: pauseButton; visible: false}
            PropertyChanges { target: playButton; visible: true}
            PropertyChanges { target: stopButton; visible: true}
        }
    ]

}

