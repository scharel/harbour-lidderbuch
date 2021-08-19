#include "NetworkRequest.h"
#include <QGuiApplication>

NetworkRequest::NetworkRequest(QObject *parent) : QObject(parent)
{
    mp_reply = NULL;
    m_busy = false;
    m_finished = false;
    m_progress = 0.0;
}

bool NetworkRequest::get(QUrl url) {
    clear();
    if (mp_reply == NULL) {
        QNetworkRequest request;
        QSslConfiguration sslConfiguration(QSslConfiguration::defaultConfiguration());
        sslConfiguration.setPeerVerifyMode(QSslSocket::VerifyNone);
        request.setSslConfiguration(sslConfiguration);
        request.setHeader(QNetworkRequest::UserAgentHeader, QGuiApplication::applicationDisplayName() +  " " + QGuiApplication::applicationVersion() + " - " + QSysInfo::machineHostName());
        request.setHeader(QNetworkRequest::ContentTypeHeader, QString("application/json").toUtf8());
        request.setUrl(url);
        mp_reply = m_manager.get(request);
        connect(mp_reply, SIGNAL(finished()), this, SLOT(onFinished()));
        connect(mp_reply, SIGNAL(downloadProgress(qint64, qint64)), this, SLOT(onDownloadProgress(qint64, qint64)));
        connect(mp_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onError(QNetworkReply::NetworkError)));
        connect(mp_reply, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
        setFinished(false);
        setBusy(true);
        return mp_reply->error() == QNetworkReply::NoError;
    }
    return false;
}

void NetworkRequest::clear() {
    if (mp_reply != NULL) {
        mp_reply->abort();
        mp_reply->deleteLater();
        mp_reply = NULL;
    }
    setBusy(false);
    setFinished(false);
    m_data.clear();
    emit dataChanged();
}

void NetworkRequest::onFinished() {
    m_data.append(mp_reply->readAll());
    mp_reply->deleteLater();
    mp_reply = NULL;
    setBusy(false);
    setFinished(true);
}

void NetworkRequest::onDownloadProgress(qint64 bytesReceived, qint64 bytesTotal) {
    if (bytesTotal != 0) {
        setProgress((double)bytesReceived / (double)bytesTotal);
    }
}

void NetworkRequest::onError(QNetworkReply::NetworkError code) {
    if (mp_reply != NULL) {
        qDebug() << mp_reply->errorString() << code;
    }
    emit errorChanged();
}

void NetworkRequest::onReadyRead() {
    m_data.append(mp_reply->read(mp_reply->bytesAvailable()));
    emit dataChanged();
}

void NetworkRequest::setBusy(bool busy) {
    if (busy != m_busy) {
        m_busy = busy;
        emit busyChanged();
    }
}

void NetworkRequest::setFinished(bool finished) {
    if (finished != m_finished) {
        m_finished = finished;
        emit finishedChanged();
    }
}

void NetworkRequest::setProgress(double progess) {
    if (progess != m_progress) {
        m_progress = progess;
        emit progressChanged();
    }
}
