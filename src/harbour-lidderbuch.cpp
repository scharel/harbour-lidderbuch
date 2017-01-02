#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QGuiApplication>
#include "datalocation.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    DataLocation dataLocation;
    view->engine()->rootContext()->setContextProperty("dataLocation", &dataLocation);

    view->setSource(SailfishApp::pathTo("qml/harbour-lidderbuch.qml"));
    view->show();
    return app->exec();
}
