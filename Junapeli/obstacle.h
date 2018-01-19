#ifndef OBSTACLE_H
#define OBSTACLE_H
#include <QObject>
#include <QTimer>
#include <QList>
#include <QQuickPaintedItem>
#include <QPainter>
#include <QSize>
#include <memory>
#include <QQmlEngine>
#include <QQmlComponent>

class Obstacle: public QQuickPaintedItem
{
    Q_OBJECT
public:
    Obstacle(QQuickItem *parent = 0);

    /**
     * @brief setCoords muuntaa rataosuuksien koordinaatit [[startX, startY, endX, endY], ...]
     *        este koordinaatti muotoon [[x,y], ...]
     * @pre coords on muunnettu xy pixeli koordinaateiksi
     * @param coords 2D var array rataosuuksien alku- ja loppupiste koordinaateista
     * @post este koordinaatit on asetettu
     */
    Q_INVOKABLE void setCoords(QVariantList coords);

    /**
     * @brief obstacleCreated lisaa peliin esteen
     * @pre obstacle != nullptr
     * @param obstacle jaettu osoitin lisattavaan esteeseen
     * @post este lisatty peliin
     * @post Poikkeustakuu: vahva
     */
    void obstacleCreated(std::shared_ptr<QObject> obstacle);

    /**
     * @brief startTimer kaynnistaa obstacleCreationTimer ajastimen
     * @post obstacleCreationTimer on kaynnistetty
     */
    void startTimer();

    /**
     * @brief stopTimer pysayttaa obstacleCreationTimer ajastimen
     * @post obstacleCreationTimer on pysaytetty
     */
    void stopTimer();

    /**
     * @brief paint arpoo piirrettavan estetyypin ja piirtaa sen ikkunaan
     * @post este on piirretty ikkunalle
     */
    void paint(QPainter *painter);

    /**
     * @brief removeObstacleAt poistaa esteen annetulla indeksilla
     * @pre i on este säiliön koon sisällä
     * @param i esteen sijainti säiliössä, 0 on pohjimmainen
     * @post Poikkeustakuu: vahva
     */
    void removeObstacleAt(unsigned int i);

    /**
     * @brief getAmount kertoo raiteilla olevien esteiden lukumaaran
     * @pre -
     * @return palauttaa senhetkisen este lukumaaran
     * @post Poikkeustakuu: nothrow
     */
    int getAmount() const;

    /**
     * @brief getRndPosition arpoo luotavalle estetyypille sijainnin
     * @pre este koordinaatit obstacleCoords on asetettu
     * @return palauttaa luotavalle esteelle sijainnin
     */
    QList<int> getRndPosition();

    /**
     * @brief getTypes kertoo estetyypit
     * @pre -
     * @return palauttaa estetyypit
     * @post Poikkeustakuu: nothrow
     */
    QList<QString> getTypes() const;

    /**
     * @brief getObstacles palauttaa raiteille luodut esteet
     * @pre -
     * @return raiteilla olevat esteet
     * @post Poikkeustakuu: nothrow
     */
    QList<std::shared_ptr<QObject>>& getObstacles();

private slots:
    void createObstacle();

private:
    QTimer obstacleCreationTimer;
    QList<std::shared_ptr<QObject>> obstacles_;
    QList<QList<int>> obstacleCoords;
    QList<QString> obstacleTypes;
    QImage obstImag;
};

#endif // OBSTACLE_H
