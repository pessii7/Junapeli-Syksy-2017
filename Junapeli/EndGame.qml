import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

/*
  EndGame-luokka hoitaa "Peli loppui" tulostuksen näytölle.
  Tämän luokan kutsuminen lopettaa pelin.
*/
Window {
    id: endGame
    width: 300
    height: 300
    color: "#090e36"
    title: "Peli loppui!"
    property string endStatus: ""
    property int obstaclesAmount: 0

    Text {
        id: endStatusText
        text: endStatus
        x: endGame.width/2 - endStatusText.width/2
        y: 50
        font.family: "Ubuntu"
        font.pointSize: 20
        color: "#08b793"
    }
    Text {
        id: endObstacles
        x: endGame.width/2 - endObstacles.width/2
        y: 90
        text: "Keräsit " + trackView.collectedObstacles + " estettä"
        font.pointSize: 15
        color: "white"
    }
    Button{
        id: endGameButton
        x: endGame.width/2 - endGameButton.width/2
        y: 250
        text: qsTr("Lopeta peli")
        onClicked: {
            endGame.close()
        }
    }
}
