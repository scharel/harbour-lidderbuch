#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QStandardPaths>
#include <QDir>

#include "NetworkRequest.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());
    app->setApplicationDisplayName("ACEL Lidderbuch");
    app->setApplicationName("harbour-lidderbuch");
    app->setApplicationVersion(APP_VERSION);
    app->setOrganizationDomain("https://github.com/scharel");
    app->setOrganizationName("harbour-lidderbuch");

    QDir dir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    dir.mkpath(".");

    qmlRegisterType<NetworkRequest>("harbour.lidderbuch", 1, 0, "NetworkRequest");

    view->setSource(SailfishApp::pathTo("qml/harbour-lidderbuch.qml"));
    view->rootContext()->setContextProperty("version", QVariant(APP_VERSION));
#ifdef QT_DEBUG
    view->rootContext()->setContextProperty("debug", QVariant(true));
#else
    view->rootContext()->setContextProperty("debug", QVariant(false));
#endif
    view->show();
    return app->exec();
}
