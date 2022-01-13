import QtQuick
import QtQuick.Controls

AbstractButton {
    id: control

    width: parent.width
    implicitHeight: 64

    checkable: true
    autoExclusive: true

    background: Rectangle {
        color: checked ? "#007fd4" : "transparent"

        Rectangle {
            anchors.fill: parent
            opacity: hovered ? 0.04 : 0
        }
    }

    contentItem: SText {
        padding: 16
        horizontalAlignment: Qt.AlignLeft
        verticalAlignment: Qt.AlignVCenter
        text: control.text
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
