#ifndef PASSENGERTRAIN_H
#define PASSENGERTRAIN_H
#include "traininterface.h"
#include <QObject>

/**
 * @brief Matkustajajunat maarittava luokka.
 * PassengerTrain on periytetty TrainInterface-rajapinnasta, eli sisältää myös senkin.
 */
class PassengerTrain: public QObject, public TrainInterface
{
    Q_OBJECT
public:
    /**
     * @brief PassengerTrain rakentaja
     * @pre -
     * @post Matkustajajunalle on asetettu kestävyys
     */
    explicit PassengerTrain(QObject *train);

    /**
     * @brief oletusarvoinen virtuaalipurkaja
     */
    virtual ~PassengerTrain() = default;

    /*!
     * @brief isUsable kertoo, onko juna käyttökelpoinen, eli onko juna rikki vai ehjä
     * @pre -
     * @return tosi, jos junan kunto (durability_) > 0
     * @post Poikkeustakuu: nothrow
     */
    virtual bool isUsable();

    /**
     * @brief durability kertoo junan kunnon tason
     * @pre -
     * @return palauttaa junan senhetkisen kunnon
     * @post Poikkeustakuu: nothrow
     */
    virtual int durability() const;

    /**
     * @brief modifyDurability muuttaa junan kunnon tasoa
     * @pre -
     * @param amount junan kunnon muutos
     * @post junan kuntoa on muutettu parametrin mukaisesti
     * @post Poikkeustakuu: vahva
     */
    virtual void modifyDurability(short amount);

    virtual QObject* getObject() const;

private:
    QObject* train_;
    int durability_;

};

#endif // PASSENGERTRAIN_H
