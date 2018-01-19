#include "game.h"
#include <QQuickItem>
#include <QDebug>

Game::Game(QObject *parent): QObject(parent), obstacle_(), shop_()
{
    collisionDetectionTimer.setInterval(500);
    connect(&collisionDetectionTimer, SIGNAL(timeout()), this, SLOT(trainCollision()));
}

void Game::startTimer()
{
    collisionDetectionTimer.start();
    obstacle_->startTimer();
}

void Game::stopTimer()
{
    collisionDetectionTimer.stop();
    obstacle_->stopTimer();
}

void Game::addNewServiceTrain(QString type)
{
    std::shared_ptr<ServiceTrain> st = std::make_shared<ServiceTrain>(type, true);
    serviceTrains_.push_back(st);
    activeServiceTrain_->setActive(false);
    activeServiceTrain_ = st;
    emit activeTrainChanged(st->getSpeed());
    emit serviceTrainDurabilityChanged(activeServiceTrain_->durabilityInPercent());
}

void Game::repair()
{
    activeServiceTrain_->modifyDurability(1000);
    emit serviceTrainDurabilityChanged(1.0);
}

void Game::objectDestroyed(QObject *ob)
{
    for (short i=0; i<passengerTrains_.size(); i++) {
        if (ob == passengerTrains_.at(i)->getObject()) {
            passengerTrains_.removeAt(i);
        }
    }
}

void Game::trainCollision()
{
    QQuickItem* st = qobject_cast<QQuickItem*>(serviceTrain_);
    for (unsigned short i=0; i<passengerTrains_.size(); i++)
    {
        QQuickItem* npc = qobject_cast<QQuickItem*>(passengerTrains_[i]->getObject());
        if (npc->mapRectToScene(npc->boundingRect()).intersects(st->mapRectToScene(st->boundingRect())))
        {
            activeServiceTrain_->modifyDurability(-10);
            if (!activeServiceTrain_->isUsable()) emit serviceTrainTotalled();

            emit serviceTrainDurabilityChanged(activeServiceTrain_->durabilityInPercent());
            emit collision(-0.1);
            qDebug() << "trains collided!";
        }

        for (unsigned short j=0; j<obstacle_->getAmount(); j++)
        {
            QQuickItem* obstacle = qobject_cast<QQuickItem*>(obstacle_->getObstacles()[j].get());
            if (obstacle->mapRectToScene(obstacle->boundingRect()).intersects(npc->mapRectToScene(npc->boundingRect())))
            {
                obstacle->deleteLater();
                obstacle_->removeObstacleAt(j);
                passengerTrains_.at(i)->modifyDurability(-50);
                if (!passengerTrains_.at(i)->isUsable()) {
                    npc->deleteLater();
                    passengerTrains_.removeAt(i);
                    emit collision(-0.1);
                }
                else { emit collision(-0.02); }
                qDebug() << "passenger train collided with obstacle!";
                goto end;
            }
        }
    } end:;
}

void Game::removeObstacle()
{
    QQuickItem* st = qobject_cast<QQuickItem*>(serviceTrain_);
    for (unsigned short i=0; i<obstacle_->getAmount(); i++)
    {
        QQuickItem* obstacle = qobject_cast<QQuickItem*>(obstacle_->getObstacles()[i].get());
        if (obstacle->mapRectToScene(obstacle->boundingRect()).intersects(st->mapRectToScene(st->boundingRect())))
        {
            obstacle->deleteLater();
            obstacle_->removeObstacleAt(i);
            emit obstacleCollected();
            break;
        }
    }
}

void Game::addNpcTrain(QObject *train)
{
    connect(train, &QObject::destroyed, this, &Game::objectDestroyed);
    std::shared_ptr<PassengerTrain> pt = std::make_shared<PassengerTrain>(train);
    passengerTrains_.push_back(pt);
    //qDebug() << passengerTrains_.size();
}

int Game::npcTrains() const
{
    return passengerTrains_.size();
}

void Game::initialize(Obstacle *obst, TrainShop *shop, QObject *train)
{
    connect(this, &Game::obstacleCollected, shop, &TrainShop::addCoupons);
    connect(shop, &TrainShop::trainTypePurchased, this, &Game::addNewServiceTrain);
    connect(shop, &TrainShop::trainRepaired, this, &Game::repair);
    shop_ = shop;

    std::shared_ptr<Obstacle> obstacle(obst);
    obstacle_ = obstacle;
    serviceTrain_ = train;
    std::shared_ptr<ServiceTrain> st = std::make_shared<ServiceTrain>("pumppuresiina", true);
    serviceTrains_.push_back(st);
    activeServiceTrain_ = st;
    emit activeTrainChanged(st->getSpeed());
}
