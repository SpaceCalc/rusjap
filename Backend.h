#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList lessons MEMBER m_lessons CONSTANT)
    Q_PROPERTY(QString error MEMBER m_error CONSTANT)

public:
    explicit Backend(QObject* parent = nullptr);

signals:

private:
    QString m_error;
    QVariantList m_lessons;
};

#endif // BACKEND_H
