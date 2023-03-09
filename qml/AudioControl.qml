import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root

    required property MediaPlayer mediaPlayer
    property bool muted: false
    property real volume: volumeSlider.value/100.

    implicitHeight: buttons.height

    RowLayout {
        anchors.fill: parent

        Item {
            id: buttons

            width: muteButton.implicitWidth
            height: muteButton.implicitHeight

            RoundButton {
                id: muteButton
                radius: 50.0
                icon.source: muted ? "qrc:/resources/Mute_Icon.svg" : "qrc:/resources/Speaker_Icon.svg"
                onClicked: { muted = !muted }
            }
        }

        Slider {
            id: volumeSlider
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            enabled: true
            to: 100.0
            value: 100.0

            background: Rectangle {
                x: volumeSlider.leftPadding
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: volumeSlider.availableWidth
                height: implicitHeight
                radius: 2
                color: "#bdbebf"

                Rectangle {
                    width: volumeSlider.visualPosition * parent.width
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }

            handle: Rectangle {
                x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 20
                radius: 13
                color: volumeSlider.pressed ? "#f0f0f0" : "#f6f6f6"
                border.color: "#bdbebf"
            }
        }
    }
}
