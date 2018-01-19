#ifndef JSONDATAREADER_H
#define JSONDATAREADER_H

#include <iostream>
#include <QObject>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QDebug>
#include <QList>
#include <QVariantList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDate>

/**
 * @brief JsonDatareader on pelissä tarvittavan json-formaattien
 * lukemisen toteuttava luokka. Luokka jäsentelee
 * reaaliaikadatan VR:n rajapinnasta, rata- ja asemadatan tiedostoista.
 */
class JsonDataReader : public QObject
{
    Q_OBJECT

public:

    /**
     * @brief JsonDataReader rakentaja
     * @param parent
     */
    explicit JsonDataReader(QObject* parent = 0);
    /**
     * @brief jsonReader kutsuu parseTrackData(), parseStationData() ja addContainers() funktioita
     */
    Q_INVOKABLE void jsonReader();

    /**
     * @brief parseTrainData luo QNetworkAccessManagerin ja lähettää get-kutsun Vr:n avoimeen rajapintaan
     * @param date on päivämäärä, joka annetaan get-kutsun yhteyteen
     */
    Q_INVOKABLE void parseTrainData();

    /**
     * @brief getData kertoo tracks_ säiliön sisällön
     * @return palauttaa sisäkkäisen Qlist:an, joka koostuu koordinaateista [[alku_long, alku_latid, loppu_long, loppu_latid]]
     * @post Poikkeustakuu: nothrow
     */
    QList<QList<double>> getData() const;

    /**
     * @brief getDataToJS muuntaa 2D tracks_ listan JavaScriptin ymmärtämään QVariantList muotoon
     */
    Q_INVOKABLE QVariantList getDataToJS() const;

    /**
     * @brief getScheduledTimes muuntaa aikataulutiedot merkkijonosta ("hh:mm") numeraaliski (int hh, int mm)
     * ja palauttaa matkustajajunien aikataulun mukaiset lahdot asemilta QVariantListana
     * @pre matkustajajunien json-data on vastaanotettu Vr:n rajapinnasta
     * @return 3D QVariantList matkustajajunien aikatauludatasta
     */
    Q_INVOKABLE QVariantList getScheduledTimes();

    /**
     * @brief getRouteCoords kertoo matkustajajunien reittikoordinaatit
     * @pre matkustajajunien json-data on vastaanotettu Vr:n rajapinnasta
     * @return 2D QVariantList matkustajajunien reittidatasta
     */
    Q_INVOKABLE QVariantList getRouteCoords();

signals:
    void finished();

private slots:
    /**
     * @brief replyFinished vastaanottaa json-tiedoston Vr:n rajapinnasta ja jäsentelee sen.
     */
    void replyFinished(QNetworkReply *);

private:
    /**
     * @brief parseTrackData jäsentelee ratadata.json tiedoston ja tallentaa sen trackData_ QMultimappiin
     */
    void parseTrackData();

    /**
     * @brief parseStationData jäsentelee asemadata.json tiedoston ja tallentaa sen stationData_ QMultimappiin
     */
    void parseStationData();

    /**
     * @brief addContainers yhdistää stationData_ ja trackData_ säiliöt sisäkkäiseen listaan tracks_
     */
    void addContainers();

    QList<QString> stationList;
    QMultiMap<QString, double> stationData_;
    QMultiMap<QString, QString> trackData_;
    QList<QList<double>> tracks_;
    QList<QList<QString>> trains_;
    QList<QList<QString>> scheduledTimes;
    QNetworkAccessManager *manager;

};

#endif // JSONDATAREADER_H
