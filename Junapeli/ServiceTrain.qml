import QtQuick 2.6

/*
  ServiceTrain on luokka, joka hoitaa huoltojunan liikumista.
  Luokka sisältää esimerkiksi nuolinäppäinten tapahtumien käsittelyn.
*/
Item {
    //anchors.fill: parent
    id: maintTrainItem;
    focus: true;
    property var mt: train
    property bool moveUp: false
    property bool moveDown: false
    property double speed: 0 // huoltojunan nopeus

    /*
      Image-komponentti asettaa huoltojunan kuva ja koon.
    */
    Image {
        id: train
        source: "resurssit/maintTrain.png"
        anchors.centerIn: parent
        rotation: 90
        width: 16; height: 46
    }

    // sidotaan attribuutit seuraamaan polkua edistyksen muuttuessa.
    x: motionPath.x;
    y: motionPath.y;
    rotation: motionPath.angle

    Timer  {
        running: true
        interval: 20
        onTriggered: {
            parent.updatePosition();
        }
        repeat: true
    }

    /*
      Funktio updatePosition pävittää huoltojunan paikkaa ruudulla
    */
    function updatePosition()
    {
        // lasketaan radan pituus
        var XY_x = line.x - path.startX;
        var XY_y = line.y - path.startY;
        var norm = Math.sqrt(Math.pow(XY_x,2)+Math.pow(XY_y,2));

        if (moveDown && track.isAtEndStation == true) { // peruuttaminen
            motionPath.progress -= speed/norm;
        }
        if (moveUp && track.isAtStartStation == true) {
            motionPath.progress += speed/norm;
        };
    }

    /*
      Keys.onPressed käsittelee käyttäjän painalluksia
    */
    Keys.onPressed:
    {
        if (event.key === Qt.Key_Left && (motionPath.progress == 0 || motionPath.progress == 1))
        {
            track.trackIndex--;
            track.changeTrack();
        }
        if (event.key === Qt.Key_Right && (motionPath.progress == 0 || motionPath.progress == 1))
        {
            track.trackIndex++;
            track.changeTrack();
        }
        if (event.key === Qt.Key_Down) { moveDown = true; }
        if (event.key === Qt.Key_Up) { moveUp = true; }
        if (event.key === Qt.Key_Space)
        {
            game.removeObstacle()
        }
    } //END: Keys.onPressed

    Keys.onReleased:
    {
        if (event.key === Qt.Key_Down) { moveDown = false; }
        if (event.key === Qt.Key_Up) { moveUp = false; }
    }

} //END: Item (maintTrainItem)
