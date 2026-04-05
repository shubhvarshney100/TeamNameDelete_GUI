#include <QApplication> // FIX: Changed from QGuiApplication to QApplication to support widgets
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "drivemanager.h"

int main(int argc, char *argv[])
{
    // FIX: Use QApplication instead of QGuiApplication
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register our C++ class to be available in QML
    qmlRegisterType<DriveManager>("com.securewipe.backend", 1, 0, "DriveManager");

    // FIX: Replaced the complex string literal with the standard QUrl constructor to fix the build error.
    const QUrl url("qrc:/qml/Main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

