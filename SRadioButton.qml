import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton {
    id: control

    leftPadding: 0
    topPadding: 0
    bottomPadding: 0


    indicator: Rectangle {
        implicitWidth: 16
        implicitHeight: implicitWidth
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: implicitWidth / 2
        color: "#3c3c3c"

        border.width: control.focus ? 1 : 0
        border.color: "#007fd4"

        Rectangle {
            implicitWidth: 8
            implicitHeight: implicitWidth
            radius: implicitWidth / 2
            anchors.centerIn: parent
            visible: checked

            color: "white"
        }

    }

    contentItem: SText {
        leftPadding: control.indicator.width + control.spacing + 2
        text: control.text
    }


    HoverHandler { cursorShape: Qt.PointingHandCursor }
}
