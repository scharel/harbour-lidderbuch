#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlContext>
#include <QGuiApplication>
#include <QStandardPaths>
#include <QDir>

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QDir dir(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    dir.mkpath(".");

    view->setSource(SailfishApp::pathTo("qml/harbour-lidderbuch.qml"));
#ifdef QT_DEBUG
    view->rootContext()->setContextProperty("debug", QVariant(true));
#else
    view->rootContext()->setContextProperty("debug", QVariant(false));
#endif
    view->show();
    return app->exec();
}
