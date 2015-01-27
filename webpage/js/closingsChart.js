var closings_by_beach = {};

d3.csv("data/beachClosings.csv", function(error, inputData) {
    inputData.forEach(function(d) {
        closings_by_beach[d.BeachName] = closings_by_beach[d.BeachName] + 1 || 1;
    });

    drawChart(closings_by_beach);

});

function drawChart(closings_by_beach) {

    $('#beachChart').highcharts({
        chart: {
            type: 'bar',
            height: 800,
        },
        title: {
            text: 'Chicago Beach Closings, 2014'
        },
        xAxis: {
            categories: Object.keys(closings_by_beach),
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
            data: Object.keys(closings_by_beach).map(function(key){return closings_by_beach[key]})
        }]
    });
}
