#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include "jsondatareader.h"
#include "game.h"
#include "obstacle.h"
#include "medals.h"
#include "trainshop.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<JsonDataReader>("JsonDataReader", 1, 0, "JsonDataReader");
    qmlRegisterType<Obstacle>("Obstacle", 1, 0, "Obstacle");
    qmlRegisterType<Game>("Game", 1, 0, "Game");
    qmlRegisterType<Medals>("Medals", 1, 0, "Medals");
    qmlRegisterType<TrainShop>("Shop", 1, 0, "Shop");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
