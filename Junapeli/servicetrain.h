#ifndef SERVICETRAIN_H
#define SERVICETRAIN_H
#include <QString>
#include <QObject>
#include "traininterface.h"

/**
 * @brief Huoltojunat maarittava luokka.
 * ServiceTrain on periytetty TrainInterface-rajapinnasta, eli sisältää myös senkin.
 */
class ServiceTrain: public QObject, public TrainInterface
{
    Q_OBJECT
public:
    /**
     * @brief ServiceTrain rakentaja
     * @pre -
     * @param type huoltojunan tyyppi
     * @param active true/false otetaanko juna kayttoon
     * @post Huoltojunalle on asetettu tyyppi, kestävyys, nopeus ja hinta
     */
    explicit ServiceTrain(QString type, bool active);

    /**
     * @brief oletusarvoinen virtuaalipurkaja
     */
    virtual ~ServiceTrain() = default;

    /**
     * @brief trainType kertoo junan tyypin
     * @pre -
     * @return palauttaa junan tyypin merkkijonona
     * @post Poikkeustakuu: nothrow
     */
    virtual QString trainType() const;

    /**
     * @brief getPrice kertoo junan ostohinnan
     * @pre -
     * @return palauttaa junan hinnan
     * @post Poikkeustakuu: nothrow
     */
    virtual int getPrice() const;

    /**
     * @brief getSpeed kertoo junan nopeustason
     * @pre -
     * @return palauttaa junan nopeuden
     * @post Poikkeustakuu: nothrow
     */
    virtual double getSpeed() const;

    /**
     * @brief durability kertoo junan kunnon tason
     * @pre -
     * @return palauttaa junan senhetkisen kunnon
     * @post Poikkeustakuu: nothrow
     */
    virtual int durability() const;

    /**
     * @brief durabilityInPercent kertoo junan kunnon tason prosenteissa
     * @pre -
     * @return palauttaa junan senhetkisen kunnon prosentteina
     * @post Poikkeustakuu: nothrow
     */
    virtual double durabilityInPercent();

    /**
     * @brief modifyDurability muuttaa junan kunnon tasoa
     * @pre -
     * @param amount junan kunnon muutos
     * @post junan kuntoa on muutettu parametrin mukaisesti
     * @post Poikkeustakuu: vahva
     */
    virtual void modifyDurability(short amount);

    /*!
     * @brief isActive kertoo, onko juna käytössä
     * @pre -
     * @return tosi, jos juna on käytössä
     * @post Poikkeustakuu: nothrow
     */
    virtual bool isActive() const;

    /**
     * @brief setActive asettaa junan käyttötilan
     * @pre -
     * @param active junan tila (true/false)
     * @post junan tila on asetettu parametrin mukaisesti
     * @post Poikkeustakuu: nothrow
     */
    virtual void setActive(bool active);

    /*!
     * @brief isUsable kertoo, onko juna käyttökelpoinen, eli onko juna rikki vai ehjä
     * @pre -
     * @return tosi, jos junan kunto (durability_) > 0
     * @post Poikkeustakuu: nothrow
     */
    virtual bool isUsable();

protected:
    QString type_;
    bool isActive_;
    int MAX_dura;
    int durability_;
    double speed_;
    int price_;

};

#endif // SERVICETRAIN_H
