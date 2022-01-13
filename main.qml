import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0

Window {
    width: 800
    height: 480
    visible: true
    title: "Russian-Japanese Trainer"

    color: "#1e1e1e"

    Rectangle {
        id: menu
        clip: true

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        implicitWidth: 200

        Behavior on width {
            PropertyAnimation {
                duration: menu.width === 0 ? 250 : 200
                easing.type: Easing.InOutCubic
            }
        }

        color: "#333333"

        ListView {
            anchors.fill: parent
            model: [ "Урок 1", "Урок 2", "Урок 3", "Урок 4", "Урок 5" ]

            delegate: MenuButton {
                text: modelData
                onClicked: {
                    startScreen.visible = false
                    preview.visible = true
                }
            }
        }
    }

    Item {
        id: startScreen
        anchors.top: parent.top
        anchors.left: menu.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16

        ColumnLayout {
            anchors.centerIn: parent

            SText {
                text: "Выберите урок для начала тренировки"
                color: "white"
            }
        }
    }

    Item {
        id: preview
        anchors.fill: startScreen
        visible: false

        ColumnLayout {
            id: previewLayout
            anchors.centerIn: parent
            spacing: 12

            SText {
                text: "Урок 1"
                font.bold: true
                factor: 1
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3c3c3c"
            }

            SText {
                text: "Количество слов: 20"
            }

            ColumnLayout {

                SText {
                    text: "Режим тренировки"
                    font.bold: true
                }

                SRadioButton {
                    text: "Русский -> Японский"
                    checked: true
                }

                SRadioButton {
                    text: "Японский -> Русский"
                }
            }

            SButton {
                Layout.topMargin: 4
                Layout.fillWidth: true
                text: "Начать"

                onClicked: {
                    menu.width = 0
                    preview.visible = false
                    lesson.visible = true
                }
            }
        }

        Rectangle {
            color: "transparent"
            border.color: "#3c3c3c"
            anchors.fill: previewLayout
            anchors.margins: -16
        }
    }

    Item {
        id: lesson
        anchors.fill: startScreen
        visible: false

        ColumnLayout {

            SText {
                text: "Урок 1"
                font.bold: true
                factor: 1
            }

            SText {
                text: "1 / 20"
                opacity: 0.7
            }

            STextButton {
                Layout.topMargin: 4
                text: "Выход"
                color: "#cf6679"

                onClicked: {
                    lesson.visible = false
                    preview.visible = true
                    menu.width = menu.implicitWidth
                }
            }
        }


        ColumnLayout {
            anchors.centerIn: parent
            spacing: 26

            ColumnLayout {
                spacing: 0

                SText {
                    text: "スパイダーマン"
                    factor: 25
                    font.bold: true
                }

                SText {
                    text: "хирагана / катакана"
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                    opacity: 0.7
                }
            }

            ColumnLayout {
                spacing: 0

                SText {
                    text: "スパイダーマン"
                    factor: 25
                    font.bold: true
                }

                SText {
                    text: "кандзи"
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
                    opacity: 0.7
                }
            }

            STextField {
                id: answer
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
            }

            SButton {
                Layout.fillWidth: true
                text: "Продолжить"

                onClicked:  {
                    lesson.visible = false
                    score.visible = true
                }
            }
        }
    }

    Item {
        id: score
        anchors.fill: startScreen
        visible: false

        ColumnLayout {
            id: scoreMenu

            SText {
                text: "Урок 1"
                font.bold: true
                factor: 1
            }

            STextButton {
                Layout.topMargin: 4
                text: "Завершить"

                onClicked: {
                    score.visible = false
                    preview.visible = true
                    menu.width = menu.implicitWidth
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 100
            spacing: 16

            SText {
                text: "Результаты"
                font.bold: true
                factor: 1
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3c3c3c"
            }

            TableView {
                id: scoreTable

                implicitWidth: calcWidth()
                implicitHeight: contentHeight

                function calcWidth() {
                    let w = 0
                    for (var i = 0; i < 4; ++i)
                        w += columnWidthProvider(i)
                    w += columnSpacing * 3
                    return w
                }

                columnWidthProvider: function(c) {
                    switch (c) {
                    case 0: return 50;
                    case 1: return 200;
                    default: return 100;
                    }
                }

                columnSpacing: 16

                model: TableModel {
                    TableModelColumn { display: "num" }
                    TableModelColumn { display: "question" }
                    TableModelColumn { display: "answer" }
                    TableModelColumn { display: "myAnswer" }

                    rows: [
                        {
                            "num": 1,
                            "question": "スパイダーマン / スパイダーマン",
                            "answer": "Привет",
                            "myAnswer" : ""
                        },
                        {
                            "num": 2,
                            "question": "スパイダーマン / スパイダーマン",
                            "answer": "Привет",
                            "myAnswer" : "пока"
                        },
                        {
                            "num": 3,
                            "question": "スパイダーマン / スパイダーマン",
                            "answer": "Привет",
                            "myAnswer" : "собака"
                        },
                        {
                            "num": 4,
                            "question": "スパイダーマン / スパイダーマン",
                            "answer": "Привет",
                            "myAnswer" : "человек"
                        }
                    ]
                }

                delegate: Item {
                    implicitHeight: 50

                    SText {
                        anchors.fill: parent
                        horizontalAlignment: Qt.AlignHCenter
                        text: display
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
