import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

/*
  InstrDialog-luokka tulostaa käyttäjälle näkyviin ohjeet.
*/
Window {
    id: instrDialog
    width: mainmenu.width
    height: mainmenu.height
    title: qsTr("Ohjeet")
    color: "#090e36"

    Button {
        id: returnButton
        x: 20
        y: 20
        text: qsTr("Takaisin")
        onClicked: {
            instrDialog.hide();
            mainmenu.show();
        }
    }

    /*
      Parent-komponentti Flickable- ja Column-komponenteille.
      Määrittää ohjeet-alueen koon.
    */
    Rectangle{
        color: "#090e36"
        width: mainmenu.width-30
        height: mainmenu.height
        x:20
        y:80

        /*
          Flickable-komponentti hoitaa ohjeille vieritysnäkymän
        */
        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: col.width
            contentHeight: col.height + lastOne.height + 40
            ScrollBar.vertical: ScrollBar { }

            /*
              Column-komponentti sisältää itse ohjeet.
            */
            Column {
                id: col
                spacing: 5
                Text {
                    font.family: "Ubuntu"
                    font.pointSize: 18
                    color: "#08b793" //#93fae5
                    text: "<b>Ohjeet</b>"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "white"
                    text: "Tervetuloa pelaamaan junapeliä!"
                    wrapMode: Text.WordWrap

                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Junapeli on peli, jossa liikutaan huoltojunalla korjaten rataverkostoa mahdollisista esteistä. " +
                          "Esteitä kerätään suojellaksemme raiteilla liikkuvia matkustajajunia. "
                    wrapMode: Text.WordWrap

                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Aloitus"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Pelin käynnistyessä aukeaa päävalikko. Päävalikossa on kolme nappia: Ratanäkymä, Mitalinäkymä ja Ohjeet. Ratanäkymä-nappia " +
                          "painamalla siirrytään ratanäkymään, joka koostuu rataverkosta, pelaajan huoltojunasta, esteistä ja matkustajajunista. " +
                          "Mitalinäkymä-nappia painettaessa avautuu näkymä pelaajan pelissä ansaitsemiin mitaleihin. " +
                          "Viimeinen nappi, Ohjeet, avaa tämän kyseisen ikkunan."
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Pelaaminen"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Pelin tarkoituksena on pitää matkustajajunien asiakkaat tyytyväisinä, poistamalla raiteilla liikkuvien matkustajajunien edeltä esteitä. " +
                          "Esteitä pelaaja poistaa omalla huoltojunallaan. Huoltojunaa pelaaja ohjaa nuolinäppäimillä ja tuhoaa esteitä välilyönnillä. " +
                          "Pelaaja voi ostaa Valtion liikkeestä paremman huoltojunan kuponkeja tai Hyppyjunan mitaleita vastaan. "
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Peli alkaa, kun ensimmäisen kerran siirrytään ratanäkymään. Ratanäkymässä pelaajalla on käytössä huoltojuna ja 100 kuponkia. " +
                          "Ratanäkymän vasemmasta yläkulmasta löytyvät Asiakastyytyväisyys ja Junan kunto. " +
                          "Yläkulmasta löytyvät myös napit, " +
                          "joilla päästään Valtion liikkeeseen sekä takaisin päävalikkoon. " +
                          "Pelaajan kuponkien määrä löytyy ratanäkymän oikeasta yläkulmasta."
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Voita peli"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Pelaaja voittaa pelin, mikäli asikastyytyväisyys on 100% ja huoltojuna on käyttökunnossa. Asiakastyytyväisyys kasvaa 5% aina kun pelaaja on poistanut esteen."
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Häviä peli"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Pelaaja häviää pelin, mikäli asikastyytyväisyys on 0% tai huoltojuna on käyttökelvoton. Asiakastyytyväisyys laskee 2%, jos matkustajajuna törmää esteeseen " +
                          "ja 10%, jos matkustajajuna menee rikki, eli törmää uudelleen esteeseen. Huoltojunan kunto heikkenee -10, jos sillä törmätään matkustajajunaan."
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Huoltojunat"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Huoltojunia on viittä eri tyyppiä. Tyypit ovat Pumppuresiina, Lättähattujuna, Höyryveturi, Luotijuna ja Hyppyjuna. Pumppujunat ovat erilaisia kestävyydeltään ja nopeudeltaan. <br>" +
                          "<strong>Pumppuresiina</strong>: Nopeus 2.5, Kunto 50, Oletus<br><strong>Lättähattujuna</strong>: Nopeus 2.9, Kunto 100, Hinta 500<br><strong>Höyryveturi</strong>: Nopeus 4.0, Kunto 100, Hinta 2000<br>" +
                          "<strong>Luotijuna</strong>: Nopeus 6.0, Kunto 50, Hinta 10000<br><strong>Futuristinenjuna</strong>: Nopeus: 10.0, Kunto: 1000, Lunastettava mitaleilla"

                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Mitalit"
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Pelissä voit ansaita myös mitaleita. Mikäli antsaitset yli 75% mitaleista saat ostettua Hyppyjunan. Mitalit säilyvät pelissä, vaikka käyttäjä lopettaisikin pelin. " +
                          "Mitalit on mahdollisuus nollata Mitalinäkymässä, mikäli käyttäjä ei halua säilyttää niitä. " +
                          "Mitaleita on neljä kappaletta.<br><strong>Juna kulkee</strong>: " +
                          "Kun aloitat pelin ensimmäisen kerran<br><strong>Extreme couponing</strong>: Kun olet käyttänyt 5000 kuponkia<br><strong>Keräilijä</strong>: Kun olet ostanut kaikki huoltojunat<br>" +
                          "<strong>Mestari</strong>: Kun olet kerännyt 25 estettä"

                    wrapMode: Text.WordWrap
                }
                Text {
                    width: mainmenu.width -30
                    font.pointSize: 14
                    color: "#09b698"
                    text: "Vinkit"
                }
                Text {
                    id: lastOne
                    width: mainmenu.width -30
                    font.pointSize: 12
                    color: "white"
                    text: "Näppäimistön 0-näppäin poistaa huoltojunan automaattisen yhdistymisen seuraavaan rataan.<br>" +
                          "Huoltojuna on keltainen ja matkustajajuna punainen."

                    wrapMode: Text.WordWrap
                }
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
            instrDialog.close();
        }
    }

}
