#include "jsondatareader.h"
#include <string>
#include <sstream>

JsonDataReader::JsonDataReader(QObject *parent): QObject(parent)
{
    stationList = {"HKI","HPJ","HPK","ILM","JNS","JY","KOK","KON","KTA","KUO","KV",
                   "LH","MI","OL","OV","PAR","PKO","PM","PNÄ","RI","SK","SL","TKU",
                   "TL","TPE","VNJ","VS","HKO","LIS","NRM","UIM","KIT","LR","LPA","MR",
                   "VTI","KNS","ÄHT","OU","VAR","VIH","JÄS","KAJ","KR","SLO","LM","HL","SNJ"};
    jsonReader();
}

void JsonDataReader::jsonReader()
{
    parseTrackData();
    parseStationData();
    addContainers();
}

void JsonDataReader::parseTrackData()
{
    QFile *jsfile = new QFile(":/resurssit/ratadata.json"); // Laita oma polku, tiedostot repossa
    if (!jsfile->open(QIODevice::ReadOnly | QIODevice::Text)) {
        std::cout << "Could not open: " << std::endl << std::flush;
        return;
    }
    QByteArray data = jsfile->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonObject obj = doc.object();
    QStringList objectKeys = obj.keys();
    jsfile->close();
    QList<QString>::iterator i;
    QList<QString>::iterator j;
    for (i = objectKeys.begin(); i != objectKeys.end(); ++i) {
        QJsonValue tracks = *(obj.find("tracks")); //array
        QJsonArray tracks_array = tracks.toArray();
        foreach (const QJsonValue & value, tracks_array) {
            QJsonObject jobj = value.toObject();
            QJsonValue trackCode = *(jobj.find("trackCode"));
            QJsonValue stations = *(jobj.find("stations"));
            QJsonArray stations_array = stations.toArray();
            foreach (const QJsonValue & value2, stations_array) {
                QJsonObject jobj2 = value2.toObject();
                QJsonValue name = *(jobj2.find("name"));
                trackData_.insert(trackCode.toString(), name.toString());
            }
        }
    }
}

void JsonDataReader::parseStationData()
{
    QFile *jsfile = new QFile(":/resurssit/asemadata.json"); // Laita oma polku, tiedostot repossa
    if (!jsfile->open(QIODevice::ReadOnly | QIODevice::Text)) {
        std::cout << "Could not open: " << std::endl << std::flush;
        return;
    }
    QByteArray data = jsfile->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray arr =doc.array();
    jsfile->close();

    foreach (const QJsonValue & value, arr) {
        QJsonObject obj = value.toObject();
        //if ((obj["type"] != "STATION") || (obj["passengerTraffic"] == false) ) {
        //    continue; }
        for (unsigned short i=0; i<stationList.length(); i++) {
            if (stationList[i] == obj["stationShortCode"].toString()) {
                stationData_.insert(obj["stationShortCode"].toString(), obj["longitude"].toDouble());
                stationData_.insert(obj["stationShortCode"].toString(), obj["latitude"].toDouble());
                break;
            }
        }
    }
}

void JsonDataReader::parseTrainData()
{
    QUrl qrl("http://rata.digitraffic.fi/api/v1/trains/" + QDate::currentDate().toString(Qt::ISODate));//QUrl has network adress
    manager = new QNetworkAccessManager(this); //create manager
    connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));//do connection with nededed signal and slot which we alredy wrote
    manager->get(QNetworkRequest(qrl)); //send get request
}

void JsonDataReader::replyFinished(QNetworkReply *reply)
{
    QList<QString> schedTimes;
    QList<QString> trainRoute;
    QByteArray data = reply->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QJsonArray arr = doc.array();
    foreach (const QJsonValue & value, arr) {
        QJsonObject obj = value.toObject();
        if (obj["trainCategory"] == "Long-distance" && obj["runningCurrently"] == true){
            std::cout << "Junan numero: " << obj["trainNumber"].toDouble() << std::endl;
            QJsonValue timetable = *(obj.find("timeTableRows"));
            QJsonArray timetable_array = timetable.toArray();
            foreach (const QJsonValue & value2, timetable_array) {
                QJsonObject obj2 = value2.toObject();
                for (unsigned short i=0; i<stationList.length(); i++) {
                    if (stationList[i] == obj2["stationShortCode"].toString()) {
                        std::cout << obj2["stationShortCode"].toString().toStdString()+ ": "+ obj2["scheduledTime"].toString().mid(11,11).toStdString() << std::endl;
                        QMultiMap<QString, double>::iterator j;
                        bool boolean = false;
                        for (j = stationData_.begin(); j != stationData_.end(); ++j) {
                            if (j.key() == stationList[i]){
                                // jos asema koordinaattia ei loydy trainRoute:sta, lisataan se
                                if (std::find(trainRoute.begin(), trainRoute.end(), QString::number(j.value())) == trainRoute.end())
                                {
                                    trainRoute.push_back(QString::number(j.value()));
                                    boolean = true;
                                }
                            }
                        }
                        if (boolean) // jos asemalle löytyi koordinaatit, asetetaan aseman junan lähtöaika
                            schedTimes.push_back(obj2["scheduledTime"].toString().mid(11,11));
                    }
                }
            }
            if (trainRoute.size() > 2) { // jätetään aika & reitti pois, jos radalle ei ole päätepistettä
                trains_.push_back(trainRoute);
                scheduledTimes.push_back(schedTimes); }
            schedTimes.clear(); trainRoute.clear();
        }
    }
    qDebug() << "trains routes: " << trains_;
    emit finished();
}

void JsonDataReader::addContainers()
{
    QList<double> koordinaatit;
    QString key = trackData_.begin().key();
    QMultiMap<QString, QString>::iterator i;
    for (i = trackData_.begin(); i != trackData_.end(); ++i) {
        if(key != i.key()){
            koordinaatit.clear();
        }
            QMultiMap<QString, double>::iterator j = stationData_.find(i.value());
            while (j != stationData_.end() && j.key() == i.value()) {
                koordinaatit.push_back(j.value());
                if(koordinaatit.size() == 4){
                    tracks_.push_back(koordinaatit);
                    koordinaatit.clear();
                    --j;
                }
                else{
                    ++j;
                }
            }
        key = i.key();
    }
}

QList<QList<double>> JsonDataReader::getData() const
{
    return tracks_;
}

QVariantList JsonDataReader::getDataToJS() const
{
    QVariantList main;
    QVariantList sub;
    for (unsigned short i = 0; i < tracks_.length(); i++) {
        sub.clear();
        for (unsigned short j = 0; j < tracks_[i].length(); j++) {
            sub.push_back(tracks_[i][j]);
        }
        main.push_back(sub);
    }
    return main;
}

QVariantList JsonDataReader::getScheduledTimes()
{
    QVariantList main;
    QVariantList sub; QVariantList sub2;
    for (unsigned short i = 0; i < scheduledTimes.size(); i++) {
        for (unsigned short j = 0; j < scheduledTimes[i].size(); j++) {
            int hh = 0; int mm = 0; char extra;
            std::string time = scheduledTimes.at(i).at(j).toStdString();
            std::stringstream ss;
            ss << time;
            ss >> hh >> extra
               >> mm >> extra;
            sub2.push_back(hh); sub2.push_back(mm);
            sub.push_back(sub2);
            sub2.clear();
        }
        main.push_back(sub);
        sub.clear();
    }
    return main;
}

QVariantList JsonDataReader::getRouteCoords()
{
    QVariantList main;
    QVariantList sub;
    for (unsigned short i = 0; i < trains_.length(); i++) {
        sub.clear();
        for (unsigned short j = 0; j < trains_[i].length(); j++) {
            sub.push_back(trains_[i][j].toDouble());
        }
        main.push_back(sub);
    }
    return main;
}
