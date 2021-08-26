#ifndef NETWORKREQUEST_H
#define NETWORKREQUEST_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QByteArray>
#include <QDebug>

class NetworkRequest : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(bool finished READ finished NOTIFY finishedChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorChanged)
    Q_PROPERTY(QByteArray data READ data NOTIFY dataChanged)
public:
    explicit NetworkRequest(QObject *parent = nullptr);

    // functions available from QML
    Q_INVOKABLE bool get(QUrl url);
    Q_INVOKABLE void clear();

    bool busy() const { return m_busy; }
    bool finished() const { return m_finished; }
    double progress() const { return m_progress; }
    int error() const { return mp_reply != NULL ? mp_reply->error() : 0; }
    QString errorString() const { return mp_reply != NULL ? mp_reply->errorString() : QString(); }
    const QByteArray& data() const { return m_data; }

signals:
    void busyChanged();
    void finishedChanged();
    void progressChanged();
    void errorChanged();
    void dataChanged();

private slots:
    void onFinished();
    void onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    void onError(QNetworkReply::NetworkError code);
    void onReadyRead();

private:
    void setBusy(bool busy);
    void setFinished(bool finished);
    void setProgress(double progess);

    QNetworkAccessManager m_manager;
    QNetworkReply* mp_reply;
    bool m_busy;
    bool m_finished;
    double m_progress;
    QByteArray m_data;
};

#endif // NETWORKREQUEST_H
