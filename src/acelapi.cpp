#include "acelapi.h"

#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

AcelApi::AcelApi(QObject *parent) : QObject(parent)
{
    acel = new QNetworkAccessManager(this);
    connect(acel, SIGNAL(finished(QNetworkReply*)), this, SLOT(onFinish(QNetworkReply*)));
    //connect(acel, SIGNAL(error(QNetworkReply*)), this, SLOT(onError(QNetworkReply*)));
    //connect(acel, SIGNAL(abort(QNetworkReply*)), this, SLOT(onAbort(QNetworkReply*)));
}

bool AcelApi::getEvents() {
    qDebug() << "Requesing ACEL events";
    QNetworkRequest request(ACEL_EVENTS);
    request.setHeader(QNetworkRequest::UserAgentHeader, "Acel Lidderbuch for SailfishOS - " + QGuiApplication::applicationVersion());
    QNetworkReply* reply = acel->get(request);
    return true;
}

bool AcelApi::getEvent(uint id) {
    qDebug() << "Requesing ACEL event" << id << ACEL_EVENT(id);
    QNetworkRequest request(ACEL_EVENT(id));
    request.setHeader(QNetworkRequest::UserAgentHeader, "Acel Lidderbuch for SailfishOS - " + QGuiApplication::applicationVersion());
    QNetworkReply* reply = acel->get(request);
    return true;
}

bool AcelApi::getSongs() {
    qDebug() << "Requesing ACEL songs";
    QNetworkRequest request(ACEL_SONGS);
    request.setHeader(QNetworkRequest::UserAgentHeader, "Acel Lidderbuch for SailfishOS - " + QGuiApplication::applicationVersion());
    QNetworkReply* reply = acel->get(request);
    return true;
}

bool AcelApi::getSong(uint id) {
    qDebug() << "Requesing ACEL song" << id << ACEL_SONG(id);
    QNetworkRequest request(ACEL_SONG(id));
    request.setHeader(QNetworkRequest::UserAgentHeader, "Acel Lidderbuch for SailfishOS - " + QGuiApplication::applicationVersion());
    QNetworkReply* reply = acel->get(request);
    return true;
}

void AcelApi::onFinish(QNetworkReply* reply) {
    if (reply->error() == QNetworkReply::NoError) {
        qDebug() << "Request finished";
        QByteArray data = reply->readAll();
        //qDebug() << data;
        QJsonDocument doc = QJsonDocument::fromJson(data); //, QJsonDocument::BypassValidation);
        if (doc.isNull())
            qDebug() << "Json Document is not valid!";
        QJsonArray json = doc.array();
        qDebug() << json.size() << "song entries";

        QJsonArray::iterator it;
        for (it = json.begin(); it != json.end(); it++)
        {
            QJsonValue song = *it;
            if (song.isNull())
                qDebug() << "Json entry is not valid!";
            QJsonObject obj = song.toObject();
            uint position = obj.find("id").value().toInt();
            QString name = obj.find("name").value().toString();
            QString cat = obj.find("category").value().toString();
            qDebug() << obj.keys() << position << name << cat;
        }
    }
    else {
        qDebug() << "Error in request" << reply->url();
    }
    reply->deleteLater();
}

void AcelApi::onError(QNetworkReply* reply) {
    if (reply->error() == QNetworkReply::NoError) {
        // TODO
    }
    reply->deleteLater();
}

void AcelApi::onAbort(QNetworkReply* reply) {
    if (reply->error() == QNetworkReply::NoError) {
        // TODO
    }
    reply->deleteLater();
}

