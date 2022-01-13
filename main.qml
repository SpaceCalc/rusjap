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

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate: MenuButton {
                implicitWidth: 200
                text: modelData["name"]

                onClicked: {
                    startScreen.visible = false
                    preview.ldata = modelData
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

        property var ldata: undefined

        ColumnLayout {
            id: previewLayout
            anchors.centerIn: parent
            spacing: 12

            SText {
                text: preview.ldata ? preview.ldata["name"] : ""
                font.bold: true
                factor: 1
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#3c3c3c"
            }

            SText {
                visible: text.length > 0
                text: preview.ldata ? preview.ldata["about"] : ""
            }

            SText {
                text: "Количество слов: " +
                    (preview.ldata ? preview.ldata["phrases"].length : 0)
            }

            ColumnLayout {

                SText {
                    text: "Режим тренировки"
                    font.bold: true
                }

                SRadioButton {
                    id: trainMode_1
                    text: "Русский -> Японский"
                    checked: true
                }

                SRadioButton {
                    id: trainMode_2
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
                    lesson.setup()
                    lesson.next()
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

        property var phrases
        property int phraseCount: 0
        property int phraseNum: 0
        property string rus
        property string hirkat
        property string kanji

        function setup()
        {
            phrases = preview.ldata["phrases"]

            // shuffle
            for (var i = phrases.length - 1; i > 0; i--)
            {
                var j = Math.floor(Math.random() * (i + 1));
                var temp = phrases[i];
                phrases[i] = phrases[j];
                phrases[j] = temp;
            }

            phraseNum = -1
            phraseCount = phrases.length
        }

        function next()
        {
            phraseNum++;

            if (phraseNum >= phraseCount)
            {
                nextStage();
            }
            else
            {
                phrases[phraseNum]["answer"] = answer.text

                rus    = phrases[phraseNum]["rus"]
                hirkat = phrases[phraseNum]["hirkat"]
                kanji  = phrases[phraseNum]["kanji"]
                answer.text = ""
                answer.forceActiveFocus()
            }
        }

        function nextStage()
        {
            let data = []

            for (var i = 0; i < lesson.phrases.length; i++)
            {
                let rus = lesson.phrases[i]["rus"]
                let hirkat = lesson.phrases[i]["hirkat"]
                let kanji = lesson.phrases[i]["kanji"]
                let myAnswer = lesson.phrases[i]["answer"]

                let jap = ""

                if (hirkat.length > 0 && kanji.length > 0)
                {
                    jap = hirkat + " / " + kanji
                }
                else if (hirkat.length > 0)
                {
                    jap = hirkat
                }
                else
                {
                    jap = kanji
                }

                let item = { }
                item["question"] = trainMode_1.checked ? rus : jap
                item["answer"] = trainMode_1.checked ? jap : rus
                item["myAnswer"] = myAnswer

                data.push(item)
            }

            scoreGrid.update(data)
            lesson.visible = false
            score.visible = true
        }

        ColumnLayout {

            SText {
                text: preview.ldata ? preview.ldata["name"] : ""
                font.bold: true
                factor: 1
            }

            SText {
                text: (lesson.phraseNum + 1) + " / " + lesson.phraseCount
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

            SText {
                visible: trainMode_1.checked
                text: lesson.rus
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                factor: 25
                font.bold: true
            }

            ColumnLayout {
                visible: trainMode_2.checked && lesson.hirkat.length > 0
                spacing: 0

                SText {
                    text: lesson.hirkat
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
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
                visible: trainMode_2.checked && lesson.kanji.length > 0
                spacing: 0

                SText {
                    text: lesson.kanji
                    Layout.fillWidth: true
                    horizontalAlignment: Qt.AlignHCenter
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
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 200
                horizontalAlignment: Qt.AlignHCenter
                onAccepted: lesson.next()
            }

            SButton {
                Layout.alignment: Qt.AlignHCenter
                implicitWidth: 200
                text: "Продолжить"

                onClicked: lesson.next()
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
                text: preview.ldata ? preview.ldata["name"] : ""
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

            ScrollView {
                id: scoreView
                Layout.fillWidth: true
                Layout.fillHeight: true

                GridLayout {
                    id: scoreGrid
                    columns: 4
                    columnSpacing: 16
                    rowSpacing: 16

                    function update(data)
                    {
                        for (var i = 0; i < scoreGrid.children.length; i++)
                            scoreGrid.children[i].destroy()

                        let c = Qt.createComponent("SText.qml")

                        for (var j = 0; j < data.length; j++)
                        {
                            c.createObject(scoreGrid, { text: j + 1 })
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
            }
        }
    }
}
