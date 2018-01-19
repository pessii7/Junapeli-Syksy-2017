#include "obstacle.h"
#include <QTime>

Obstacle::Obstacle(QQuickItem *parent): QQuickPaintedItem(parent)
{
    obstacleCreationTimer.setInterval(5000);
    connect(&obstacleCreationTimer, SIGNAL(timeout()), this, SLOT(createObstacle()));
    qsrand( QDateTime::currentDateTime().toTime_t() );
    obstacleTypes = {":/resurssit/car.png",":/resurssit/car2.png",":/resurssit/car3.png",
                     ":/resurssit/tree.png",":/resurssit/rocks.png",":/resurssit/protesters.png"};
}

void Obstacle::obstacleCreated(std::shared_ptr<QObject> obstacle)
{
    obstacles_.push_back(obstacle);
}

void Obstacle::setCoords(QVariantList coords)
{
    QList<int> sub;
    for (short i=0; i<coords.length(); i++) {
        QList<QVariant> p = coords[i].toList();
        for (short j=0; j<p.length(); j++) {
            sub.push_back(p[j].toInt());
            if (sub.length() == 2) {
                obstacleCoords.push_back(sub);
                sub.clear(); }
        }
    }
    for (short i=0; i<obstacleCoords.length(); i++) {
        for (short j=i+1; j<obstacleCoords.length(); j++) {
            if (obstacleCoords[i] == obstacleCoords[j])
                obstacleCoords.removeAt(i); }}
}

void Obstacle::startTimer()
{
    obstacleCreationTimer.start();
}

void Obstacle::stopTimer()
{
    obstacleCreationTimer.stop();
}

QList<int> Obstacle::getRndPosition()
{
    QList<int> pos = obstacleCoords.at(qrand() % obstacleCoords.size());
    pos[0] = pos[0]-24; pos[1] = pos[1]-24;
    return pos;
}

void Obstacle::removeObstacleAt(unsigned int i)
{
    obstacles_.removeAt(i);
}

int Obstacle::getAmount() const
{
    return obstacles_.size();
}

QList<QString> Obstacle::getTypes() const
{
    return obstacleTypes;
}

QList<std::shared_ptr<QObject> > &Obstacle::getObstacles()
{
//    QList<std::shared_ptr<QObject>> obstacles;
//    for (std::shared_ptr<QObject> obstacle: obstacles_)
//    {
//        obstacles.push_back(obstacle);
//    }
//    return obstacles;
    return obstacles_;
}

void Obstacle::paint(QPainter *painter)
{
    obstImag.load(getTypes().at(qrand() % getTypes().size()));
    obstImag = obstImag.scaled(QSize(48,48),Qt::AspectRatioMode::KeepAspectRatio);
    painter->save();
    QRect source(0, 0, obstImag.width(), obstImag.height());
    painter->drawImage(source, this->obstImag);
    painter->restore();
}

void Obstacle::createObstacle()
{
    QQmlEngine engine;
    QQmlComponent component(&engine, QUrl("qrc:/Obstacle.qml"));
    std::shared_ptr<QQuickItem> object(qobject_cast<QQuickItem*>(component.create()));
    //QQmlEngine::setObjectOwnership(object.get(), QQmlEngine::CppOwnership);
    //object->setParent(this);
    object->setParentItem(this);
    QList<int> pos = getRndPosition();
    object->setPosition(QPoint(pos[0],pos[1]));
    obstacleCreated(object);
}
