#ifndef MEDALS_H
#define MEDALS_H

#include <iostream>
#include <QString>
#include <QObject>
#include <QDebug>
#include <QStringList>
#include <QFile>
#include <QTextStream>
#include <QIODevice>
#include <QList>

/**
 * @brief Medals on mitalien tallennuksen toteuttava luokka.
 */
class Medals: public QObject
{
    Q_OBJECT

public:
    /**
     * @brief Medals rakentaja
     * @param parent
     */
    explicit Medals(QObject* parent = 0);

    /**
     * @brief saveMedals tallentaa Qml:stä saadun
     * QvariantListan tekstitiedostoon.
     * @pre jokainen mitali on medals listan eri alkio
     * @param medals on QVariantList, joka sisältää pelaajan mitallit.
     * @post Pelaajan mitallit on talletettu tekstitiedostoon.
    */
    Q_INVOKABLE void saveMedals(QVariantList medals);

    /**
     * @brief readMedals lukee mitallit tekstitiedostosta.
     * @pre -
     * @post mitalit on luettu tekstitiedosta luokan jäsenmuuttujaan
    */
    Q_INVOKABLE void readMedals();

    /**
     * @brief getMedals palauttaa mitalit Qml:ään
     * @pre -
     * @return palauttaa mitalit QVariantList:nä
     * @post Poikkeustakuu: nothrow
    */
    Q_INVOKABLE QVariantList getMedals();

private:
    QString filename_ = "medals.txt";
    QVariantList savedMedals_;

};

#endif // MEDALS_H
