d3.csv("data/beachClosings.csv", function(error, beachClosings) {

    beachClosings.getByNumClosings = new function() {
        var closingsByBeach = {};
        beachClosings.forEach(function(d) {
            var thisBeachName = d.beachName;
            closingsByBeach[thisBeachName] = closingsByBeach[thisBeachName] + 1 || 1;
        });

        var afterSort = sortObject(closingsByBeach);

        return afterSort
    }

    beachClosings.getByDate = new function() {
        var closingsByDate = {};
        beachClosings.forEach(function(d) {
            var thisDate = d.closedDate;
            closingsByDate[thisDate] = closingsByDate[thisDate] + 1 || 1;
        });

        var afterSort = sortObject(closingsByDate);

        return afterSort
    }

    drawChart(beachClosings.getByDate);

});

function drawChart(beaches) {

    var beachNames = [];
    var closings = [];

    beaches.forEach(function(b) {
        beachNames.push(b.name);
        closings.push(b.closings);
    });

    $('#beachChart').highcharts({
        chart: {
            type: 'bar',
            height: 800,
        },
        title: {
            text: 'Chicago Beach Closings, 2014'
        },
        xAxis: {
            categories: beachNames,
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
        },
        series: [{
            data: closings
        }]
    });
}

function sortObject(obj) {
    var arr = [];
    for (var prop in obj) {
        if (obj.hasOwnProperty(prop)) {
            arr.push({
                'name': prop,
                'closings': obj[prop]
            });
        }
    }
    arr.sort(function(a, b) { return b.closings - a.closings; });
    //arr.sort(function(a, b) { a.value.toLowerCase().localeCompare(b.value.toLowerCase()); }); //use this to sort as strings

    return arr; // returns array
}