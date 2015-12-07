#ifndef ACELAPI_H
#define ACELAPI_H

#include <QObject>
#include <QGuiApplication>
#include <QAbstractTableModel>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#define ACEL_EVENTS QUrl("https://dev.acel.lu/api/v1/events")
#define ACEL_EVENT(ID) QUrl(QString("https://dev.acel.lu/api/v1/events/%1").arg(ID))
#define ACEL_SONGS QUrl("https://dev.acel.lu/api/v1/songs")
#define ACEL_SONG(ID) QUrl(QString("https://dev.acel.lu/api/v1/songs/%1").arg(ID))

class AcelApi : public QObject
{
    Q_OBJECT
public:
    explicit AcelApi(QObject *parent = 0);

signals:

private:
    QNetworkAccessManager *acel;
    QNetworkReply *reply;

private slots:
    // when all data recieved
    void onFinish(QNetworkReply*);
    // when error occurred
    void onError(QNetworkReply*);
    // abort download and delete file
    void onAbort(QNetworkReply*);

public slots:
    bool getEvents();
    bool getEvent(uint id);

    bool getSongs();
    bool getSong(uint id);
};

// TODO, see http://doc.qt.io/qt-5/qtquick-modelviewsdata-cppmodels.html
class SongsModel : public QAbstractTableModel
{
    Q_OBJECT
public:
    SongsModel(QObject *parent = 0);
    int rowCount() { return songs.length(); }
    int columnCount() { return columns; }
    data();
private:
    QList<QStringList> songs;
    const int columns = 5;
};

#endif // ACELAPI_H
