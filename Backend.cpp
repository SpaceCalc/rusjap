#include "Backend.h"
#include <QGuiApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDebug>

Backend::Backend(QObject* parent) : QObject(parent)
{
    auto appDirPath = qApp->applicationDirPath();

    auto db = QSqlDatabase::addDatabase("QODBC", "xlsx_connection");

    db.setDatabaseName(
        "DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};"
        "DBQ=" + appDirPath + "/lessons.xlsx");

    if (!db.open())
    {
        qDebug() << db.lastError().text();
        return;
    }

    QSqlQuery query(db);

    if (!query.exec("select * from [" + QString("about") + "$]"))
    {
        qDebug() << query.lastError().text();
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
}

