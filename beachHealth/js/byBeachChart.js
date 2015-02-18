//See: https://github.com/pablojim/highcharts-ng
var myapp = angular.module('byBeachApp', ["highcharts-ng"]);

myapp.controller('byBeachCtrl', function ($scope) {

    $scope.descendingByBeach = function() {

        $scope.removeCurrentSeries();
        closings = sortClosings(closingsByBeach, "descending");

        var rnd = Object.keys(closings).map(function(key){return closings[key]})
        var thekeys = Object.keys(closings);

        $scope.byBeachNG.series.push({
            data: rnd
        })

        $scope.byBeachNG.xAxis.categories = thekeys;

    }

    $scope.ascendingByBeach = function() {

        $scope.removeCurrentSeries();
        closings = sortClosings(closingsByBeach, "ascending");

        var rnd = Object.keys(closings).map(function(key){return closings[key]})
        var thekeys = Object.keys(closings);

        $scope.byBeachNG.series.push({
            data: rnd
        })

        $scope.byBeachNG.xAxis.categories = thekeys;

    }

    $scope.removeCurrentSeries = function () {
        var seriesArray = $scope.byBeachNG.series
        var rndIdx = Math.floor(Math.random() * seriesArray.length);
        seriesArray.splice(rndIdx, 1)
    }

    $scope.byBeachNG = {
        options: {
            chart: {
                type: 'bar',
                height: 800,
            }
        },
        series: [],
        title: {
            text: '2014 Closed Days By Beach'
        },
        loading: false,
        xAxis: {
            categories: [],
            title: {
                text: "Beaches"
            },
            labels: {
                step:1,
            }
        },
        yAxis: {
            min: 0,
            title: {
                text: 'Closings (2014)',
                align: 'high'
            },
            labels: {
                overflow: 'justify'
            }
        },
        plotOptions: {
            bar: {
                dataLabels: {
                    enabled: true
                }
            },
            series: {
                pointWidth: 20
            }
        },
        credits: {
            enabled: false
        },
        legend: {
            enabled: false
        }

    }

});

function sortClosings(obj, direction) {
    var arr = [];
    for (var prop in obj) {
        if (obj.hasOwnProperty(prop)) {
            arr.push({
                'name': prop,
                'closings': obj[prop]
            });
        }
    }
    
    if (direction == "descending") {
        arr.sort(function(a, b) { return b.closings - a.closings; });
    }
    else {
        arr.sort(function(a, b) { return a.closings - b.closings; });
    }

    var retObj = {};
    for (var i=0; i < arr.length; i++) {
        retObj[arr[i].name] = arr[i].closings;
    }

    return retObj; // returns array
}