import QtQuick 2.6
import QtQuick.Window 2.2
import QtQml.Models 2.1
import QtQuick.Controls 2.2
import QtMultimedia 5.8 // Audio
import Obstacle 1.0
import Game 1.0

/*
  TrackView on luokka joka hoitaa pelin ratanäkymää.
  Luokkaan sisältyy pelin kartta, pelin kello, pelin informaatio-
  palkit ja siirtymiset Valtion liikkeeseen ja takaisin päävalikkoon.
*/
Window {
    id: trackView
    minimumWidth: 660
    maximumWidth: 660
    minimumHeight: 720
    maximumHeight: 720
    title: qsTr("Ratanäkymä")
    property bool autoConnect: true
    property var scheduledDepartures: [] // matkustajajunien aikataulun mukaiset lahdot asemilta
    property var routeCoords: [] // matkustajajunien reitti koordinaatit
    property int hourCounter: 7 // pelin sisaisen ajankulun tuntilaskuri. aloitetaan klo 07:00
    property int minuteCounter: 0 // pelin sisaisen ajankulun minuuttilaskuri
    property int collectedObstacles: 0 // kerättyjen esteiden määrä
    onVisibleChanged: {
        if (trackView.visible) {
            maintTrain.focus = true;
            game.startTimer();
            timer.start();
            gameTimer.start();
            playMusic.play();}
        else {
            maintTrain.focus = false;
            game.stopTimer();
            timer.stop();
            gameTimer.stop();
            playMusic.stop();}
    }

    /*
      TrainShop-luokka joka tuodaan näkyviin.
    */
    TrainShop { id: trainShop; }

    /*
      EndGame-luokka, joka tuodaan näkyviin
    */
    EndGame { id: endGame; }

    /*
      Map-luokka, joka tuodaan näkyviin.
    */
    Map {
        anchors.fill: parent
        id: map

        /*
          Column-komponentti, joka toimii peli informaatio-palkkina.
        */
        Column {
            id: statusView
            width: customerHappiness.width
            height: 416
            spacing: 8
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: qsTr("Asiakastyytyväisyys")
                font.pixelSize: 14
            }
            ProgressBar {
                id: customerHappiness
                value: 0.5
                width: trackView.width*0.2
            }
            Text {
                text: qsTr("Junan kunto")
                font.pixelSize: 14
            }
            ProgressBar {
                id: trainHealth
                value: 1.0
                width: trackView.width*0.2
            }
            Text {
                text: "Junan tyyppi: " + trainShop.trainType
                font.pixelSize: 14
            }
            Button {
                id: shopButton
                text: qsTr("Valtion liike")
                onClicked: {
                    trackView.hide();
                    trainShop.show();
                }
            }
            Button {
                id: returnButton
                text: qsTr("Takaisin")
                onClicked: {
                    trackView.hide();
                    mainmenu.show();
                }
            }
        } //END: Column (statusView)

        /*
          TrainNetwork-luokka, joka tuodaan näkyviin.
        */
        TrainNetwork {
            id: track;
            PathInterpolator {
                id: motionPath;
                path: Path { id: path; PathLine {id: line;} }
            }
        } //END: Rataverkko (track)

        /*
          Canvas-komponentti piirtää radat asemien välille
        */
        Canvas {
            id: trackCanvas;
            anchors.fill: parent;
            onPaint: {
                var ctx = getContext("2d")
                // piirron asetus
                ctx.lineWidth = 3
                ctx.strokeStyle = "gray";
                for (var i=0; i<track.coordsXY.length; i++) {
                    // uuden viivan piirron aloitus
                    ctx.beginPath();
                    // aloitus piste
                    ctx.moveTo(track.coordsXY[i][0],track.coordsXY[i][1]);
                    // loppu piste
                    ctx.lineTo(track.coordsXY[i][2],track.coordsXY[i][3]);
                    // viivan piirto lineWidth & strokeStyle ominaisuuksilla
                    ctx.stroke()
                }
            }
        }

        ServiceTrain { id: maintTrain; }

        /*
          Game on C++ komponentti, joka hoitaa pelin alustusta, sekä pelin tapahtumien
          ilmoitusta Qml puolelle.
        */
        Game { id: game;
            Component.onCompleted: game.initialize(obstacle, trainShop.shp, maintTrain.mt)
            onActiveTrainChanged: maintTrain.speed = speed;
            onCollision: {
                popup.open()
                popupTimer.running = true
                customerHappiness.value += amount;
                if(customerHappiness.value == 0){
                    endGame.endStatus = "Hävisit pelin!"
                    trackView.close()
                    endGame.show()
                }
            }
            onServiceTrainDurabilityChanged: trainHealth.value = durability;
            onObstacleCollected: {
                customerHappiness.value += 0.05
                collectedObstacles += 1
                if (collectedObstacles >= 25){
                    if (medals.indexOf("Mestari") < 0){
                        mainmenu.medals.push("Mestari")
                    }
                    medalView.refreshGrid()
                }
                if(customerHappiness.value == 1){
                    endGame.endStatus = "Voitit pelin!"
                    trackView.close()
                    endGame.show()
                }
            }
            onServiceTrainTotalled: {
                endGame.endStatus = "Hävisit pelin!"
                trackView.close()
                endGame.show()
            }
        }
        Obstacle { id: obstacle; }

        /*
          Timer-komponentti pelin sisäiseen kelloon.
        */
        Timer  { id: gameTimer
            running: false; repeat: true
            interval: 50 // pelin minuutti (50ms)
            onTriggered: {
                minuteCounter++;
                if (minuteCounter == 60) {
                    hourCounter++;
                    if (hourCounter == 24) hourCounter = 7; //aloitetaan vrk. klo. 07:00
                    minuteCounter = 0;
                }
                for (var i=0; i<scheduledDepartures.length; i++) {
                    if (game.npcTrains() < 4 && scheduledDepartures[i][0][0] === hourCounter &&
                            scheduledDepartures[i][0][1] === minuteCounter)
                    {
                        var component = Qt.createComponent("PassengerTrains.qml");
                        var train = component.createObject(map,
                                                           {"routes": routeCoords[i],
                                                            "departureTimes": scheduledDepartures[i]});
                        game.addNpcTrain(train.imag)
                    }
                } //console.log(hourCounter+":"+minuteCounter) // hh:mm log print
            }
        }

        /*
          Popup-ilmoitus, joka ilmoittaa käyttäjälle, jos pelissä
          tapahtuu törmäys.
        */
        Popup {
            id: popup
            x: trackView.width/2 -popupText.width/2
            y: trackView.height/2 -popupText.height/2
            Rectangle{
                anchors.fill: parent
                color: "transparent"
                Text{
                    id: popupText
                    text: qsTr("Törmäys")
                    color: "red"
                    font.pixelSize: 30
                }
            }
            focus: false
            Timer{
                id: popupTimer
                interval: 1000; running: false
                onTriggered:{
                    popup.close()
                }
            }
        }

        Text {
            id: couponsText
            x: trackView.width - couponsText.width -20
            y: 20
            text: "Kupongit: " + trainShop.coupons
            font.pixelSize: 20
        }

        Text {
            id: notification
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20;
            PropertyAnimation { // tekstin fade out animaatio
                id: txtAnim
                target: notification
                property: "opacity"
                from:1; to: 0
                duration: 2500
            }
            onTextChanged: {
                txtAnim.restart();
            }
        }

        // trainShop ikkunan avaus
        Keys.onEscapePressed:
        {
            trackView.hide();
            trainShop.show();
        }
        // Risteettömien rataosuuksien automaattisen yhdistyksen asetus
        Keys.onDigit0Pressed: {
            if (autoConnect) {
                autoConnect = false;
                notification.text="Ratojen autom. yhdistys: OFF"}
            else {
                autoConnect = true;
                notification.text="Ratojen autom. yhdistys: ON"}
        }

    } //END: Kartta (map)


    Timer  {
        id: timer
        running: false
        interval: 20
        onTriggered: {
            // Tarkistaa onko huoltojuna saapunut rataosuuden päähän.
            track.checkProgress();
            // Risteettömän rataosuuden automaattinen yhdistys?
            if (autoConnect) track.connectTracks();
        } repeat: true
    }

    Audio {
        id: playMusic;
        volume: 0.1
        loops: Audio.Infinite
        source: "resurssit/remove.mp3";
    }

} // END: Window (trackView)
