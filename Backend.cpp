#include "Backend.h"
#include <QGuiApplication>
#include <QDir>

Backend::Backend(QObject* parent) : QObject(parent)
{
    auto appDirPath = qApp->applicationDirPath();

    QDir lessonsDir = appDirPath + "/lessons";

    if (!lessonsDir.exists())
        lessonsDir.mkpath(".");

    auto files = lessonsDir.entryInfoList({ "*.csv" }, QDir::Files);

    for (auto& file : files)
    {
        QString path = file.absoluteFilePath();

        QVariantList phrases;
        QString error = parse(path, phrases);

        QVariantMap lesson;
        lesson["path"] = path;
        lesson["name"] = file.baseName();
        lesson["error"] = error;
        lesson["phrases"] = phrases;

        m_lessons.push_back(lesson);
    }
}

QString Backend::parse(const QString& filePath, QVariantList& phrases)
{
    return {};
}
