import QtQuick
import QtQuick.Layouts 1.15

SText {
    property bool num: false
    Layout.minimumWidth: num ? 25 : 70
    horizontalAlignment: num ? Qt.AlignLeft : Qt.AlignHCenter
}
