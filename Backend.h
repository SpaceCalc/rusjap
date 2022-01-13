#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class Backend : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantList lessons MEMBER m_lessons CONSTANT)

public:
    explicit Backend(QObject* parent = nullptr);

signals:

private:
    QVariantList m_lessons;

    QString parse(const QString& filePath, QVariantList& phrases);
};

#endif // BACKEND_H
