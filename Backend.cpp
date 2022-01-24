#include "Backend.h"
#include <QGuiApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>

Backend::Backend(QObject* parent) : QObject(parent)
{
    auto appDirPath = qApp->applicationDirPath();

    if (!QDir(appDirPath).exists("lessons.xlsx"))
    {
        m_error = "Отсутствует файл lessons.xlsx";
        return;
    }

    auto db = QSqlDatabase::addDatabase("QODBC", "xlsx_connection");

    db.setDatabaseName(
        "DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};"
        "DBQ=" + appDirPath + "/lessons.xlsx");

    if (!db.open())
    {
        m_error = "Ошибка базы данных\n" + db.lastError().text();
        return;
    }

    QSqlQuery query(db);

    if (!query.exec("select * from [" + QString("about") + "$]"))
    {
        m_error = "Ошибка базы данных\n" + query.lastError().text();
        return;
    }

    QVector<QPair<QString, QString>> tables;

    while (query.next())
    {
        auto table = query.value(0).toString();
        auto about = query.value(1).toString();

        tables.push_back({table, about});
    }

    for (const auto& [ table, about ] : tables)
    {
        bool ok = query.exec("select * from [" + table + "$]");

        if (!ok)
        {
            continue;
        }

        QVariantList phrases;

        while (query.next())
        {
            auto rus = query.value(0).toString();
            auto hirkat = query.value(1).toString();
            auto kanji = query.value(2).toString();

            rus = rus.simplified();
            hirkat = hirkat.simplified();
            kanji = kanji.simplified();

            if (rus.isEmpty() || (hirkat.isEmpty() && kanji.isEmpty()))
                continue;

            QVariantMap map;
            map["rus"] = rus;
            map["hirkat"] = hirkat;
            map["kanji"] = kanji;

            phrases.append(map);
        }

        QVariantMap lesson;
        lesson["name"] = table;
        lesson["about"] = about.simplified();
        lesson["phrases"] = phrases;

        m_lessons.append(lesson);
    }

    db.close();

    if (m_lessons.empty())
    {
        m_error = "В файле lessons.xlsx нет доступных уроков";
    }
}

