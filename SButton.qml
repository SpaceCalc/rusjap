import QtQuick 2.15
import QtQuick.Controls 2.15

AbstractButton {
    id: control
    checkable: false

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 28
        color: !control.enabled ? Qt.darker("#3c3c3c", 1.5) : control.down ? Qt.darker("#3c3c3c", 1.1) : "#3c3c3c"

        border.width: control.focus ? 1 : 0
        border.color: "#007fd4"

        Rectangle {
            anchors.fill: parent
            visible: control.enabled
            color: "white"
            opacity: hovered ? 0.04 : 0
        }
    }

    contentItem: SText {
        text: control.text
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        opacity: !control.enabled ? 0.5 : 1
    }

    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
