#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>

#include "Backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Backend>("rusjap.backend", 1, 0, "Backend");

    QQmlApplicationEngine engine;
    const QUrl url(QString("qrc:/rusjap/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
