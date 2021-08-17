#ifndef WGET_H
#define WGET_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDebug>


class Wget : public QObject
{
    Q_OBJECT
public:
    explicit Wget(QObject *parent = nullptr);

signals:

private:
    QNetworkAccessManager _manager;
    QNetworkReply* _reply;


};

#endif // WGET_H
