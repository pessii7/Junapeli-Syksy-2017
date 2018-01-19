#ifndef TRAININTERFACE_H
#define TRAININTERFACE_H

/**
 * @brief TrainInterface maarittaa rajapinnan junille.
 */
class TrainInterface
{

public:
    /**
     * @brief Rajapintaluokan oletusrakentaja (olemassa dokumentaatiota varten).
     */
    TrainInterface() = default;

    /**
     * @brief Rajapintaluokassa on oletusarvoinen virtuaalipurkaja (olemassa, koska kantaluokalla tulee olla virtuaalipurkaja).
     */
    virtual ~TrainInterface() = default;

    /*!
     * @brief isUsable kertoo, onko juna käyttökelpoinen, eli onko juna rikki vai ehjä
     * @pre -
     * @return tosi, jos junan kunto (durability) > 0
     * @post Poikkeustakuu: nothrow
     */
    virtual bool isUsable() = 0;

    /**
     * @brief durability kertoo junan kunnon tason
     * @pre -
     * @return palauttaa junan senhetkisen kunnon
     * @post Poikkeustakuu: nothrow
     */
    virtual int durability() const = 0;

    /**
     * @brief modifyDurability muuttaa junan kunnon tasoa
     * @pre -
     * @param amount junan kunnon muutos
     * @post junan kuntoa on muutettu parametrin mukaisesti
     * @post Poikkeustakuu: vahva
     */
    virtual void modifyDurability(short amount) = 0;
};

#endif // TrainInterface_H
