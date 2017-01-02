#ifndef DATALOCATION_H
#define DATALOCATION_H

#include <QStandardPaths>
#include <QQmlEngine>
#include <QQmlContext>
#include <QDir>

class DataLocation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path)
public:
    DataLocation(QObject* parent = 0) : QObject(parent)
    {
        QDir dir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
        if (!dir.exists()) {
            dir.mkpath(".");
        }
    }
    QString path() const {
        return QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    }
};

#endif // DATALOCATION_H
