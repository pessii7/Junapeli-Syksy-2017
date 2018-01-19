import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.5
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.1
import JsonDataReader 1.0
import Medals 1.0

/*
  Tämä on pelin Qml-pääluokka. Luokka hoitaa päävalikon
  näkymän, joka sisältää kolme painiketta, päävalikon tekstin,
  sekä pelin alustuksesta kertovan ladataan-ilmoituksen. Luokka myös alustaa
  pelin reaaliaikadatan ja tiedostoista saadut rata- ja asemadatan.
*/
Window {
    id: mainmenu;
    visible: true;
    width: 640
    height: 580
    color: "#090e36"
    opacity: 1
    title: qsTr("Päävalikko")
    property bool ready: false
    property bool load: false
    property var medals: []
    property string medalInfo: ""
    Component.onCompleted: {
        medalSaver.readMedals()
        medals = medalSaver.getMedals()
    }

    /*
      Qml-luokkien, sekä C++-luokan
      JsonDataReader-luokan näkyviin tuominen.
    */
    TrackView { id: trackView; }
    MedalView { id: medalView; }
    InstrDialog { id: instrDialog; }
    Medals { id: medalSaver; }
    JsonDataReader {
        id: json
        onFinished:{
            indicator.running = false
            ready = true
            mainmenu.hide();
            trackView.show();
            trackButton.enabled = true
            medalButton.enabled = true
            instrButton.enabled = true
            trackView.scheduledDepartures = json.getScheduledTimes()
    }}

    /*
      Parent-komponentti päävalikon painikkeille ja ladataan-ilmoitukselle.
    */
    Rectangle {
        id: rectangle
        x: 207
        width: 226
        height: 209
        color: "#090e36"
        anchors.topMargin: 207
        anchors.top: parent.top

        /*
          Ratanäkymä-painike alustaa kutsuu C++-luokkaa JsonDataReader,
          avaa ratanäkymän, päivittää mitalit ja hoitaa lataus-ilmoituksen
          käynnistymisen. JsonDataReader alustaa reaaliaika-, rata ja asemadatan.
        */
        Button {
            id: trackButton
            x: 63
            y: 39
            width: 100
            height: 40
            text: qsTr("Ratanäkymä")
            onClicked: {
                if (ready == false){
                    indicator.running = true
                    json.parseTrainData()
                    trackButton.enabled = false
                    medalButton.enabled = false
                    instrButton.enabled = false
                    if (medals.indexOf("Juna kulkee") < 0){
                        medals.push("Juna kulkee")
                    }
                    medalView.refreshGrid()
                }
                else{
                    mainmenu.hide();
                    trackView.show();
                }
            }
        }

        /*
          Mitalinäkymä-painike, joka avaa mitalinäkymän.
        */
        Button {
            id: medalButton
            x: 63
            y: 85
            width: 100
            height: 40
            text: qsTr("Mitalinäkymä")
            onClicked: {
                medalView.show();
                medalView.refreshGrid()
            }
        }

        /*
          Ohjeet-painike, joka avaa ohjeet.
        */
        Button{
            id: instrButton
            x: 63
            y: 131
            text: qsTr("Ohjeet")
            onClicked: {
                instrDialog.show();
            }
        }

        /*
          Pelin alustuksesta kertova ladataan-ilmoitus.
        */
        BusyIndicator {
            id: indicator
            y: 256
            rotation: 0
            scale: 1
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
            running: false
            Text {
                id: name
                visible: indicator.running
                x: -52
                y: -49
                text: qsTr("Odota hetki: Peliä alustetaan...")
                font.pointSize: 8
                color: "#ebe6cb"
            }
        }
    }

    /*
      Päävalikon otsikko-teksti.
    */
    Text {
        id: text1
        x: 230
        y: 97
        width: 180
        height: 67
        color: "#ffffff"
        text: qsTr("Junapeli")
        font.weight: Font.Medium
        opacity: 0.8
        font.pixelSize: 50
    }

} //END: Window (mainmenu)
