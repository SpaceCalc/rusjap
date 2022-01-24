import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: control

    selectByMouse: true
    selectionColor: "#0c69d8"

    font.pointSize: 10
    color: "white"

    verticalAlignment: Qt.AlignVCenter

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 28
        color: "#3c3c3c"

        border.width: control.focus ? 1 : 0
        border.color: "#007fd4"
    }
}
