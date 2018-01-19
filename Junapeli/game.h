#ifndef GAME_H
#define GAME_H
#include <QObject>
#include <QTimer>
#include <memory>
#include "servicetrain.h"
#include "traininterface.h"
#include "passengertrain.h"
#include "futuristictrain.h"
#include "obstacle.h"
#include "trainshop.h"
class Obstacle;

class Game: public QObject
{
    Q_OBJECT //macro for signal/slot mechanism.

public:
    explicit Game(QObject *parent = 0);

    /**
     * @brief startTimer kaynnistaa esteiden luonti- ja tormayksen havaitsemis ajastimen
     * @post obstacleCreationTimer ja collisionDetectionTimer on kaynnistetty
     */
    Q_INVOKABLE void startTimer();

    /**
     * @brief stopTimer pysayttaa esteiden luonti- ja tormayksen havaitsemis ajastimen
     * @post obstacleCreationTimer ja collisionDetectionTimer on pysaytetty
     */
    Q_INVOKABLE void stopTimer();

    /**
     * @brief initialize suorittaa rakentajan jalkeiset alustustoimenpiteet
     * @pre metodia ei ole kutsuttu aikaisemmin
     * @post Poikkeustakuu: perus
     */
    Q_INVOKABLE void initialize(Obstacle *obst, TrainShop *shop, QObject *train);

    Q_INVOKABLE void removeObstacle();

    /**
     * @brief addNpcTrain lisaa peliin uuden matkustajajunan
     * @param train osoitin luotuun juna objektiin
     * @post matkustajajuna lisatty
     */
    Q_INVOKABLE void addNpcTrain(QObject* train);

    /**
     * @brief trains kertoo liikenteessa olevien matkustajajunien maaran
     * @return matkustajajunien lukumaara
     */
    Q_INVOKABLE int npcTrains() const;

signals:
    /**
     * @brief serviceTrainTotalled lahetetaan, kun pelaajan juna tuhoutuu
     */
    void serviceTrainTotalled();

    /**
     * @brief serviceTrainDurabilityChanged lahetetaan, kun huoltojunan kunto muuttuu
     * (juna tormaa/korjataan, tai junatyyppi vaihtuu)
     * @param durability huoltojunan senhetkinen kestavyys prosentteina
     */
    void serviceTrainDurabilityChanged(double durability);

    /**
     * @brief collision lahetetaan, kun pelaajan juna ja npc juna tormaavat,
     * tai jos npc juna osuu esteeseen
     * @param amount asiakastyytyvaisyyden menetyksen maara (prosentteina)
     */
    void collision(double amount);

    /**
     * @brief obstacleCollected lahetetaan, kun pelaaja poistaa esteen raiteelta
     */
    void obstacleCollected();

    /**
     * @brief activeTrainChanged lahetetaan, kun pelaaja vaihtaa junatyyppia
     * @param speed_ pelaajan käyttöönottaman junan nopeus
     */
    void activeTrainChanged(double speed);

private slots:
    /**
     * @brief lisaa pelaajalle uuden huoltojunan, kun pelaaja ostaa valtioliikkeesta junan
     * @param type lisattavan huoltojunan tyyppi
     * @post uusi huoltojuna lisatty peliin
     */
    void addNewServiceTrain(QString type);

    /**
     * @brief repair korjaa pelaajan kaytossa olevan junan kunnon maksimiin
     * @post aktiivisena oleva huoltojuna on korjattu
     */
    void repair();

    void trainCollision();
    void objectDestroyed(QObject* ob);

private:
    QTimer collisionDetectionTimer;
    std::shared_ptr<Obstacle> obstacle_;
    //std::shared_ptr<TrainShop> shop_;
    TrainShop* shop_;
    QObject* serviceTrain_;
    QList<std::shared_ptr<ServiceTrain>> serviceTrains_;
    QList<std::shared_ptr<PassengerTrain>> passengerTrains_;
    std::shared_ptr<ServiceTrain> activeServiceTrain_;
    std::shared_ptr<FuturisticTrain> futuristicTrain_;

};

#endif // GAME_H
