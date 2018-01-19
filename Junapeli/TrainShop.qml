import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import Shop 1.0

/*
  TrainShop-luokka, käsittelee Valtion liike-näkymää. Luokka sisältää
  tällä hetkellä käytössä olevan huoltojunan tyypin, pelaajan kupongit,
  käyttäjän junat ja käyetyt kupongit. Luokassa on myös popup-ikkuna ja
  funktio, joka tarkastaa onko pelaajan mahdollista ostaa uusi huoltojuna ja
  lisää tietyn tyyppisiä mitaleita.
*/
Window {
    id: trainShop
    width: mainmenu.width;
    height: mainmenu.height
    title: qsTr("Valtion liike")
    color: "#090e36"
    property var shp: shop
    property string trainType: "pumppuresiina"
    property int coupons: 100
    property var userTrains: []
    property int usedCoupons: 0

    Shop { id: shop; onCouponsChanged: coupons = coupons_ }

    /*
      Popup-ikkuna, joka ilmoittaa käyttäjälle, jos hänellä ei ole varaa
      uuteen huoltojunaan.
    */
    Popup {
        id: popup
        x: mainmenu.width/2 -popup.width/2
        y: mainmenu.height/2 -popup.height/2
        Text{
            id: popupText
            color: "black"
            font.pixelSize: 14
        }
        focus: true
        Timer{
            id: popupTimer
            interval: 1500; running: false
            onTriggered:{
                popup.close()
            }
        }
    }

    /*
      checkCoupons-funktio tarkastelee käyttäjän valitsemaa junaa ja sen hintaa.
      Mikäli hinta on suurempi kuin käyttäjän kuponkien määrä, käyttäjä saa ilmoituksen
      Popup-ikkunalla. Funktio myös tarkastelee onko käyttäjä oikeutettu mitaleihin:
      Keräilijä ja Extreme couponing.
    */
    function checkCoupons(type, price){
        if (trainType === type && coupons >= price/2){
            shop.repair(price/2) // korjaa pelaajan kaytossa olevan junan
            userTrains.push(type)
            usedCoupons = usedCoupons + price/2
            trainShop.hide()
            trackView.show()
        }
        else {
            if (coupons < price){
                popup.open()
                popupText.text = "Sinulla ei ole tarpeeksi kuponkeja"
                popupTimer.running = true
            }
            else {
                trainType = type
                shop.trainPurchased(type,price)
                userTrains.push(type)
                usedCoupons = usedCoupons + price
                trainShop.hide()
                trackView.show()
            }
        }
        if (userTrains.length == 4){
            if (medals.indexOf("Keräilijä") < 0){
                mainmenu.medals.push("Keräilijä")
            }
            userTrains = []
            medalView.refreshGrid()
        }
        if (usedCoupons > 500){
            if (medals.indexOf("Extreme couponing") < 0){
                mainmenu.medals.push("Extreme couponing")
            }
            userTrains = []
            medalView.refreshGrid()
        }
    }

    /*
      Ratanäkymä-nappi, joka siirtää
      käyttäjän takaisin ratanäkymään.
    */
    Button {
        id: button
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 12
        text: qsTr("Ratanäkymä")
        onClicked: {
            trainShop.hide();
            trackView.show();
        }
    }

    /*
      Column-komponentti, joka sisältää Kupongit tekstin ja
      käyttäjän kuponkien määrän tekstinä.
    */
    Column {
        id: rightColumn
        anchors.topMargin: 12
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.top: parent.top
        Text {
            text: qsTr("Kupongit: ")
            color: "#ffffff"
            font.pixelSize: 18
        }
        Label {
            id: couponsLabel
            text: coupons;
            color: "#ffffff"
            font.family: "Courier"
            font.pointSize: 18
        }
    }


    /*
      Grid on käyttöliittymä komponentti, joka tulee näkyviin ruudulle. Grid sisältää
      huoltojunien kuvat, nimet ja "painikkeet" jokaiselle junalle. Painike käynnistää
      checkCoupons-funktion.
    */
    Grid {
        id: grid
        columns: 3
        spacing: 100
        x: (parent.width/2) - (grid.width/2)
        y: (parent.height/2) - (grid.height/2)
        Rectangle{
            width: 128
            height: 128
            color: "#090e36"
            Image {
                id: handcar
                source: "resurssit/handcar.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkCoupons("pumppuresiina", 100)
                    }
                }
            }
            Text {
                id: handcarText
                text: qsTr("Pumppuresiina")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.horizontalCenter: handcar.horizontalCenter
                anchors.top: handcar.bottom
            }
        }
        Rectangle{
            width: 128
            height: 128
            color: "#090e36"
            Image {
                id: flatHatTrain
                source: "resurssit/flatHatTrain.png"
                width: 128
                height: 128
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkCoupons("lättähattu", 500)
                    }
                }
            }
            Text {
                id: flatHatTrainText
                text: qsTr("Lättähattujuna")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.horizontalCenter: flatHatTrain.horizontalCenter
                anchors.top: flatHatTrain.bottom
            }
        }
        Rectangle {
            width: 128
            height: 128
            color: "#090e36"
            Image {
                id: steamTrain
                source: "resurssit/steamTrain.png"
                width: 128
                height: 128
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkCoupons("höyryveturi", 2000)
                    }
                }
            }
            Text {
                id: steamTrainText
                text: qsTr("Höyryveturi")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.horizontalCenter: steamTrain.horizontalCenter
                anchors.top: steamTrain.bottom
            }

        }
        Rectangle {
            width: 128
            height: 128
            color: "#090e36"
            Image {
                id: bulletTrain
                source: "resurssit/bulletTrain.png"
                width: 128
                height: 128
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        checkCoupons("luotijuna", 10000)
                    }
                }
            }
            Text {
                id: bulletTrainText
                text: qsTr("Luotijuna")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.horizontalCenter: bulletTrain.horizontalCenter
                anchors.top: bulletTrain.bottom
            }
        }
        Rectangle {
            width: 128
            height: 128
            color: "#090e36"
            Image {
                id: futuristicTrain
                source: "resurssit/futuristicTrain.png"
                width: 128
                height: 128
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (mainmenu.medals.length >= 3){
                            trainType = "futuristinenjuna"
                            shop.trainPurchased(trainType, 0)
                            trainShop.hide()
                            trackView.show()
                        }
                        else {
                            popup.open()
                            popupText.text = "Sinulla ei ole tarpeeksi mitaleita"
                            popupTimer.running = true
                        }
                    }
                }
            }
            Text {
                id: futuristicTrainText
                text: qsTr("Futuristinenjuna")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.horizontalCenter: futuristicTrain.horizontalCenter
                anchors.top: futuristicTrain.bottom
            }
        }
    }

    /*
      Käyttäjän painaessa esc-näppäintä suoritetaan tämä.
    */
    Item {
        focus: true
        Keys.onEscapePressed:
        {
            trainShop.hide()
            mainmenu.show();
        }
    }

} //END: Window (trainShop)
