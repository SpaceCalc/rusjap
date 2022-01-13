import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import rusjap.backend 1.0

Window {
    width: 800
    height: 480
    visible: true
    title: "Russian-Japanese Trainer"

    color: "#1e1e1e"

    Backend {
        id: backend
    }

    Rectangle {
        id: menu
        clip: true

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        width: 200

        function hide()
        {
            menuAnimation.duration = 200
            menu.width = 0
        }

        function show()
        {
            menuAnimation.duration = 250
            menu.width = 200
        }

        Behavior on width {
            PropertyAnimation {
                id: menuAnimation
                easing.type: Easing.InOutCubic
            }
        }

        color: "#333333"

        ListView {
            anchors.fill: parent
            model: backend.lessons

            delegate: MenuButton {
                text: modelData["name"]

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
                    menu.hide()
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
                    menu.show()
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

                    let data = [
                            {
                                "question" : "スパイダーマン / スパイダーマン",
                                "answer" : "Привет",
                                "myAnswer" : "пока"
                            },
                            {
                                "question" : "スパイダーマン / スパイダーマン",
                                "answer" : "Привет",
                                "myAnswer" : ""
                            },
                            {
                                "question" : "スパイダーマン / スパイダーマン",
                                "answer" : "Привет",
                                "myAnswer" : "Пока"
                            }
                        ]

                    scoreGrid.update(data)
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
                    menu.show()
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 150
            spacing: 16

            SText {
                text: "Результаты"
                font.bold: true
                factor: 1
            }

            Rectangle {
                implicitWidth: scoreGrid.width
                height: 1
                color: "#3c3c3c"
            }

            GridLayout {
                id: scoreGrid
                columns: 4
                columnSpacing: 16
                rowSpacing: 16

                function update(data)
                {
                    for (var i = 0; i < scoreGrid.children.length; i++)
                        scoreGrid.children[i].destroy()

                    let c = Qt.createComponent("SCell.qml")

                    for (var j = 0; j < data.length; j++)
                    {
                        c.createObject(scoreGrid, { text: j, num: true })
                        c.createObject(scoreGrid, { text: data[j]["question"] })
                        c.createObject(scoreGrid, { text: data[j]["answer"]   })

                        if (data[j]["myAnswer"].length === 0)
                        {
                            c.createObject(scoreGrid,
                                { text: "нет", color: "#cf6679" })
                        }
                        else
                        {
                            c.createObject(scoreGrid,
                                { text: data[j]["myAnswer"] })
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
