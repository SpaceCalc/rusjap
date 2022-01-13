#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<Backend>("rusjap.backend", 1, 0, "Backend");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/rusjap/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
