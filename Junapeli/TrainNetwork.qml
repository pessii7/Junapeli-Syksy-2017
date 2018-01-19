import QtQuick 2.0

/*
  TrainNetwork on luokka, joka hoitaa rataverkostoa.
  Luokka sisältää funktiota, joilla esimerkiksi alustetaan asemat,
  vaihdetaan rataosuutta ja tarkastellaan rataosuuksia.
*/
Item {
    id: trackItem
    anchors.fill: parent

    // coordsXY: [[startX,startY,endX,endY], ...] tai [[endX,endY,startX,startY], ...]
    property var coordsXY: [] // asemien pixeli (x,y) koordinaatit
    property int trackIndex: 0
    property bool isAtEndStation: false
    property bool isAtStartStation: true

    /*
      Funktio initializeTracks alustaa asemien koordinaatit
      ja huoltojunan aloitus pisteen.
    */
    function initializeTracks() {
        coordsXY = map.geoCoordsToPixel(map.geoCoordinates);
        routeCoords = map.geoCoordsToPixel(json.getRouteCoords())

        // jarjestetaan routeCoords helpommin kasiteltavaan muotoon.
        var mainArray = []; var subArray = [];
        for (var i = 0; i < routeCoords.length; i++) {
            var sub2Array = [];
            for (var j = 0; j < routeCoords[i].length; j++) {
                sub2Array.push(routeCoords[i][j])
                if (sub2Array.length == 2) {
                    subArray.push(sub2Array)
                    sub2Array = [] }
            }
            if (subArray.length === scheduledDepartures[i].length)
                mainArray.push(subArray);
            subArray = [];
        } routeCoords = mainArray;

        obstacle.setCoords(coordsXY);

        // huoltojunan aloitus pisteen asetus
        path.startX = coordsXY[0][0];
        path.startY = coordsXY[0][1];
        line.x = coordsXY[0][2];
        line.y = coordsXY[0][3];
    }

    /*
      Funktio changeTrack suorittaa rataosuuden vaihdon asemalla:
    */
    function changeTrack()
    {
        var currentTrack = [path.startX,path.startY,line.x,line.y];
        var tracks = stationTracks();

        if (trackIndex < 0) trackIndex = tracks.length-1;
        else if (trackIndex >= tracks.length) trackIndex = 0;

        if (!isIntersection() && compareArrays(tracks[trackIndex],currentTrack)) {
            trackIndex++;
            if (trackIndex >= tracks.length) trackIndex = 0;}

        if ((motionPath.x === tracks[trackIndex][0] &&
             motionPath.y === tracks[trackIndex][1]))
        {
            path.startX = tracks[trackIndex][0]; // aloituspisteen asetus
            path.startY = tracks[trackIndex][1];
            line.x = tracks[trackIndex][2];      // loppupisteen asetus
            line.y = tracks[trackIndex][3];
            motionPath.progress = 0;
        }
        else if ((motionPath.x === tracks[trackIndex][2] &&
                  motionPath.y === tracks[trackIndex][3]))
        {
            path.startX = tracks[trackIndex][2];
            path.startY = tracks[trackIndex][3];
            line.x = tracks[trackIndex][0];
            line.y = tracks[trackIndex][1];
            motionPath.progress = 0;
        }
    }

    /*
      Funktio isIntersection tarkastelee onko asema risteysasema.
    */
    function isIntersection() {
        var tracks = stationTracks();
        if (tracks.length > 2) { return true; }
        else { return false; }
    }

    /*
      Funktio stationTracks palauttaa aseman yhteydessä
      olevat rataosuudet.
    */
    function stationTracks() {
        var tracks = []; var currentTrack = [path.startX,path.startY,line.x,line.y];
        for (var i = 0; i < coordsXY.length; i++)
        {
            if ((motionPath.x === coordsXY[i][0] && motionPath.y === coordsXY[i][1]) ||
                    (motionPath.x === coordsXY[i][2] && motionPath.y === coordsXY[i][3]))
            {
                tracks.push(coordsXY[i]);
            }
        }
        return tracks;
    }

    /*
      Funktio compareArrays vertailee kahden arrayn välistä yhtäläisyttä.
      Funktio palauttaa true, jos arrayt a ja b ovat samat.
    */
    function compareArrays(a, b) {
        if (a.length !== b.length) { return false; }
        var a_ = []; var b_ = [];
        for (var i=0; i<a.length; i++) {
            a_.push(a[i]); b_.push(b[i]);
        }
        a_.sort(); b_.sort(); var count = 0;
        for (var j=0; j<a_.length; j++) {
            if (a_[j] === b_[j]) { count++; }
        }
        if (count == 4) return true;
        else return false;
    }

    /*
      Funktio checkProgress tekee tarkistuksen onko juna saapunut rataosuuden päähän
    */
    function checkProgress() {
        if (motionPath.progress == 1) {
            isAtEndStation = true; isAtStartStation = false; }
        if (motionPath.progress == 0) {
            isAtStartStation = true; isAtEndStation = false; }
    }

    /*
      Funktio connectTracks yhdistää raiteosuudet automaattisesti, jos pisteessä ei ole risteystä
    */
    function connectTracks() {
        if (motionPath.progress == 1 && !isIntersection())
        {
            changeTrack();
        }
    }

} //END: Item
