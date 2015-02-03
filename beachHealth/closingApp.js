//See: https://github.com/pablojim/highcharts-ng
var myapp = angular.module('myapp', ["highcharts-ng"]);

myapp.controller('myctrl', function ($scope) {

    $scope.showClosingsByBeach = function() {

        var closings = beachClosings.getByNumClosings;
        $scope.removeCurrentSeries();

        var rnd = Object.keys(closings).map(function(key){return closings[key]})
        var thekeys = Object.keys(closings);

        $scope.highchartsNG.series.push({
            data: rnd
        })

        $scope.highchartsNG.xAxis.categories = thekeys;
        
        $scope.highchartsNG.title.text = "Beach Closings By Beach";

    }

    $scope.showClosingsByDate = function() {

        var closings = beachClosings.getByDate;
        $scope.removeCurrentSeries();

        var rnd = Object.keys(closings).map(function(key){return closings[key]})
        var thekeys = Object.keys(closings);

        $scope.highchartsNG.series.push({
            data: rnd
        })

        $scope.highchartsNG.xAxis.categories = thekeys;
        
        $scope.highchartsNG.title.text = "Beach Closings By Date";

    }

    $scope.removeCurrentSeries = function () {
        var seriesArray = $scope.highchartsNG.series
        var rndIdx = Math.floor(Math.random() * seriesArray.length);
        seriesArray.splice(rndIdx, 1)
    }

    $scope.highchartsNG = {
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