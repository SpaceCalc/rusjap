import QtQuick
import QtQuick.Controls

AbstractButton {
    id: control

    property color color: "#007fd4"

    contentItem: SText {
        text: control.text
        color: control.color
        font.underline: control.focus
    }

    background: null

    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
