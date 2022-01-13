import QtQuick 2.15
import QtQuick.Controls 2.15

AbstractButton {
    id: control

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
