import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

/*
  MedalView-luokka hoitaa käyttäjän mitaleiden tulostamisen ruudulle.
  MedalView-luokka myös sisältää refreshGrid-funktion, joka päivittää
  mitalien määrää näytölle.
*/
Window {
    id: medalView
    width: mainmenu.width
    height: mainmenu.height
    title: qsTr("Mitalinäkymä")
    color: "#090e36"
    property alias grid: grid

    /*
      TrainShop-luokan näkyviin tuominen.
    */
    TrainShop { id: trainShop; }

    /*
      Takaisin-painike, jolla päästään takaisin
      päävalikkoon
    */
    Button {
        id: returnButton
        x: 20
        y: 20
        text: qsTr("Takaisin")
        onClicked: {
            medalView.hide();
            mainmenu.show();
        }
    }

    /*
      Nollaa-painike, joka poistaa käyttäjän mitalit pelistä ja
      tiedostosta.
    */
    Button {
        id: resetButton
        x: mainmenu.width - resetButton.width - 20
        y: 20
        text: qsTr("Nollaa mitalit")
        onClicked: {
            mainmenu.medals = [];
            trainShop.userTrains = []
            trainShop.usedCoupons = 0
            trackView.collectedObstacles = 0
            refreshGrid()
        }
    }

    /*
      Grid on käyttöliittymä komponentti, joka tulee näkyviin ruudulle. Grid sisältää
      mitalit ja niiden nimet.
    */
    Grid {
        id: grid
        columns: 4
        rows: 1
        spacing: 35
        x: (parent.width/2) - (grid.width/2)
        y: (parent.height/2) - (grid.height/2)

        Rectangle {
            color:"#090e36"
            width: 100; height: 100
            Image{
                id: firstMedal
                visible: false
                source:"resurssit/medal.png";
                width: 120; height: 120}
            Text{
                id: firstText
                text: "Juna kulkee"
                visible: false
                color: "#ffffff"
                font.pixelSize: 18
                anchors.horizontalCenter: firstMedal.horizontalCenter;
                anchors.top: firstMedal.bottom
            }
        }
        Rectangle {
            color:"#090e36"
            width: 100; height: 100
            Image{
                id: secondMedal
                visible: false
                source:"resurssit/medal.png";
                width: 120; height: 120}
            Text{
                id: secondText
                text: "Extreme couponing"
                visible: false
                color: "#ffffff"
                font.pixelSize: 18
                anchors.horizontalCenter: secondMedal.horizontalCenter;
                anchors.top: secondMedal.bottom
            }
        }
        Rectangle {
            color:"#090e36"
            width: 120; height: 120
            Image{
                id: thirdMedal
                visible: false
                source:"resurssit/medal.png";
                width: 120; height: 120}
            Text{
                id: thirdText
                text: "Keräilijä"
                visible: false
                color: "#ffffff"
                font.pixelSize: 18
                anchors.horizontalCenter: thirdMedal.horizontalCenter;
                anchors.top: thirdMedal.bottom
            }
        }
        Rectangle {
            color:"#090e36"
            width: 120; height: 120
            Image{
                id: fourthMedal
                visible: false
                source:"resurssit/medal.png";
                width: 120; height: 120}
            Text{
                id: fourthText
                text: "Mestari"
                visible: false
                color: "#ffffff"
                font.pixelSize: 18
                anchors.horizontalCenter: fourthMedal.horizontalCenter;
                anchors.top: fourthMedal.bottom
            }
        }
    }

    /*
      refreshGrid-funktio päivittää Mitalinäkymää, sitä mukaan kuin käyttäjä ansaitsee mitaleita.
      Funktio myös kutsuu C++-luokkaa Medals, ja sen funktiota
      saveMedals, joka tallettaa tämän hetkiset mitalit tiedostoon.
    */
    function refreshGrid(){
        medalSaver.saveMedals(medals)
        var size = mainmenu.medals.length
        if (size == 0){
            firstMedal.visible = false
            firstText.visible = false
            secondMedal.visible = false
            secondText.visible = false
            thirdMedal.visible = false
            thirdText.visible = false
            fourthMedal.visible = false
            fourthText.visible = false
        }
        for (var i = 0; i < size; i++){
            var medal = mainmenu.medals[i]
            if (medal === "Juna kulkee"){
                firstMedal.visible = true
                firstText.visible = true
            }
            else if (medal === "Extreme couponing"){
                secondMedal.visible = true
                secondText.visible = true
            }
            else if (medal === "Keräilijä"){
                thirdMedal.visible = true
                thirdText.visible = true
            }
            else if (medal === "Mestari"){
                fourthMedal.visible = true
                fourthText.visible = true
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
            medalView.close();
        }
    }


}
