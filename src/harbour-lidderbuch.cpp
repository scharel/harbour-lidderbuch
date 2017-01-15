#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
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
    view->show();
    return app->exec();
}
