import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer

    implicitHeight: 20


    RowLayout {
        anchors.fill: parent

        Text {
            id: mediaTime
            Layout.minimumWidth: 50
            Layout.minimumHeight: 18
            horizontalAlignment: Text.AlignRight
            text: {
                var m = Math.floor(mediaPlayer.position / 60000)
                var ms = (mediaPlayer.position / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }
        }

        Slider {
            id: mediaSlider
            Layout.fillWidth: true
            enabled: mediaPlayer.seekable
            to: mediaPlayer.duration
            value: mediaPlayer.position
            stepSize: 0.01
            snapMode:Slider.SnapOnRelease

            background: Rectangle {
                x: mediaSlider.leftPadding
                y: mediaSlider.topPadding + mediaSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: mediaSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: mediaSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }

            handle: Rectangle {
                x: mediaSlider.leftPadding + mediaSlider.visualPosition * (mediaSlider.availableWidth - width)
                y: mediaSlider.topPadding + mediaSlider.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 20
                radius: 13
                color: mediaSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }

            onMoved: {
                mediaPlayer.setPosition(value)
            }
            onPressedChanged: {
                mediaPlayer.pause()
                mediaPlayer.play()
            }
        }

        Text {
            id: mediaTotalTime
            Layout.minimumWidth: 50
            Layout.minimumHeight: 18
            horizontalAlignment: Text.AlignRight
            text: {
                var len_m = Math.floor(mediaPlayer.duration / 60000)
                var len_ms = (mediaPlayer.duration / 1000 - len_m * 60).toFixed(1)
                return `${len_m}:${len_ms.padStart(4, 0)}`
            }
        }
    }
}
