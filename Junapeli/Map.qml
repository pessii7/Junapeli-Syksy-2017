import QtQuick 2.0
import QtLocation 5.6
import QtQuick.Window 2.0
import QtPositioning 5.6

/*
  Map-luokka hoitaa kartan tulostuksen ruudulle.
*/
Item {
    anchors.fill: parent
    property var geoCoordinates: json.getDataToJS(); // asemien maantieteelliset koordinaatit

    Plugin {
        id: mapPlugin
        name: "osm" // "mapboxgl", "esri", ...
        // specify plugin parameters if necessary
        // PluginParameter {
        //     name:
        //     value:
        // }
    }

    /*
      Map-komponentti on pelin kartta. Kartan valmistuessa
      kutsutaan myös TrainNetwork-luokan alustusfunktiota
      initializeTracks().
    */
    Map {
        id: map;
        anchors.fill: parent
        plugin: mapPlugin
        // Kartan keskipiste (Konnevesi)
        center: QtPositioning.coordinate(62.6277663, 26.29385419999994)
        // Lukitaan zoomaustaso
        minimumZoomLevel: 6.5
        maximumZoomLevel: 6.5

        //onZoomLevelChanged: { track.updateTracks(); }
        //onCenterChanged: { track.updateTracks(); }
        onMapReadyChanged: { track.initializeTracks(); }

        MapPolyline {
            id: polyline;
            line.width: 2
            line.color: 'black'
            path: [
                //{ latitude: 61.498056, longitude: 23.760833 },
                //{ latitude: 62.240278 , longitude: 25.744444 }
            ]
        }

    } //END: Map

    /*
      Funktio geoCoordsToPixel muuntaa koordinaatit (latitude,longitude) pixeli koordinaateiksi (x,y)
      ja palauttaa asemien xy koordinaatit.
    */
    function geoCoordsToPixel(latlon)
    {
        var pixelArray = [];
        for (var i = 0; i < latlon.length; i++) {
            var pixels = [];
            for (var j = 0; j < latlon[i].length-1; j++) {
                var x = 0; var y = 0;
                x = map.fromCoordinate(QtPositioning.coordinate(latlon[i][j],latlon[i][j+1])).x;
                y = map.fromCoordinate(QtPositioning.coordinate(latlon[i][j],latlon[i][j+1])).y;
                pixels.push(Math.round(x));
                pixels.push(Math.round(y));
                j++;
            }
            pixelArray.push(pixels);
        }
        return pixelArray;
    }

} //END: Item
