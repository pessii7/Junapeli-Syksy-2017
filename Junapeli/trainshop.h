#ifndef TRAINSHOP_H
#define TRAINSHOP_H
#include <QObject>

/**
 * @brief Valtion liike maarittava luokka.
 * TrainShop on periytetty QObject luokasta, eli sisaltaa myos senkin.
 */
class TrainShop: public QObject
{
    Q_OBJECT
public:
    /**
     * @brief oletusrakentaja
     * @post pelaajan aloitus kupongit on asetettu
     */
    explicit TrainShop();

    /**
     * @brief getCoupons kertoo pelaajan kuponkien lukumaaran
     * @pre -
     * @return palauttaa pelaajan senhetkisen kuponki maaran
     * @post Poikkeustakuu: nothrow
     */
    int getCoupons() const;

    /**
     * @brief trainPurchased vahentaa pelaajan kuponkimaaraa junan ostohinnan verran, ja viestittaa
     * peli-luokalle osto tapahtumasta
     * @pre -
     * @param type ostettu junatyyppi
     * @param price junan ostohinta
     * @post Poikkeustakuu: nothrow
     */
    Q_INVOKABLE void trainPurchased(QString type, int price);

    /**
     * @brief repair vahentaa pelaajan kuponkimaaraa junan korjaushinnan verran, ja viestittaa peli-
     * luokalle korjauksesta
     * @param price junan korjaushinta (puolet ostohinnasta)
     * @post Poikkeustakuu: nothrow
     */
    Q_INVOKABLE void repair(short price);

public slots:
    /**
     * @brief addCoupons lisaa pelaajalle kuponkeja, kun pelaaja keraa esteen pois raiteilta
     */
    void addCoupons();

signals:
    /**
     * @brief couponsChanged lahetetaan, kun pelaajan kuponki tilanne muuttuu
     * @param coupons pelaajan senhetkinen kuponki maara
     */
    void couponsChanged(int coupons_) const;

    /**
     * @brief trainTypePurchased lahetetaan, kun pelaaja ostaa liikkeesta uuden junan
     * @param type pelaajan ostama junatyyppi
     */
    void trainTypePurchased(QString type);

    /**
     * @brief trainRepaired lahetetaan, kun pelaaja on maksanut junan korjauksesta
     */
    void trainRepaired();

private:
    int coupons_;
};

#endif // TRAINSHOP_H
