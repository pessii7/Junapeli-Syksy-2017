import QtQuick 2.6

/*
  PassengerTrains-luokka hoitaa matkustajajunien liikkeet.
  Luokka sisältää mm. piirron kartalle PathInterpolator:lla.
*/
Item {
    anchors.fill: parent
    id: route
    property var routes: []
    property var departureTimes: [] // [ [hh,mm], [hh,mm], ... ]
    property var imag: train
    property int departureIndex: 0
    property int routeIndex: 0
    Component.onCompleted: {
        rata.startX = routes[0][0]; rata.startY=routes[0][1];
        line.x=routes[1][0]; line.y=routes[1][1];
        animator.duration = item.setDuration(0);
        animator.start(); }

    PathInterpolator {
        id: motionPath
        path: Path { id: rata; PathLine { id: line } }

        NumberAnimation on progress {
            id: animator
            running: false
            from: 0; to: 1;
            //duration: item.setDuration(0)
            onStopped: { item.setRoute(); }
        }
    } // END: PathInterpolator

    Item {
        id: item

        function setRoute() {
            if (motionPath.x === routes[routes.length-1][0] &&
                    motionPath.y === routes[routes.length-1][1])
            {
                //console.log("a train animation duration timeout. route destroyed!")
                route.destroy();
            }

            else {
                routeIndex += 1
                rata.startX = routes[routeIndex][0]; rata.startY = routes[routeIndex][1]
                line.x = routes[routeIndex+1][0]; line.y = routes[routeIndex+1][1]
                motionPath.progress = 0;

                departureIndex++;
                animator.duration = setDuration(departureIndex);
                animator.start()
            }
        }

        function setDuration(index) {
            var mm = 0 // total minutes
            if (departureTimes[index][0] > 12) // 13-23 to 1-11
                mm = ((departureTimes[index][0] % 13)+1)*60 + departureTimes[index][1];
            else
                mm = departureTimes[index][0]*60 + departureTimes[index][1];

            var mm2 = 0; index++
            if (departureTimes[index][0] > 12)
                mm2 = ((departureTimes[index][0] % 13)+1)*60 + departureTimes[index][1];
            else
                mm2 = departureTimes[index][0]*60 + departureTimes[index][1];

            var duration = 0
            if (mm2 > mm) duration = (mm2 - mm)*100
            else duration = (mm - mm2)*100

            if (duration > 6000) duration = 6000;
            return duration;
        }

        Image {
            id: train
            source: "resurssit/passengerTrain.png"
            anchors.centerIn: parent
            rotation: 90
            width: 16
            height: 46
        }

        // sidotaan attribuutit seuraamaan polkua edistyksen muuttuessa.
        x: motionPath.x;
        y: motionPath.y;
        rotation: motionPath.angle

    } // END: Item

} // END: BorderImage
