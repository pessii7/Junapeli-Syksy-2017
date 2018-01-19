#ifndef FUTURISTICTRAIN_H
#define FUTURISTICTRAIN_H
#include "servicetrain.h"

/**
 * @brief Futuristisen junatyypin maarittava luokka.
 * FuturisticTrain on periytetty ServiceTrain luokasta, eli sisältää myös senkin.
 */
class FuturisticTrain: public ServiceTrain
{
public:
    /**
     * @brief FuturisticTrain rakentaja
     * @post Junalle on asetettu tyyppi, kestävyys, nopeus ja hinta
     */
    explicit FuturisticTrain();

    /**
     * @brief oletusarvoinen virtuaalipurkaja
     */
    virtual ~FuturisticTrain() = default;

    //TODO: erikoisominaisuus?
    void specialAbility();

//private:
//    QString type_;
//    bool isActive_;
//    int MAX_dura;
//    int durability_;
//    double speed_;
//    int price_;
};

#endif // FUTURISTICTRAIN_H
