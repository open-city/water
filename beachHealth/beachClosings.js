var beachClosings;

d3.csv("data/beachClosings.csv", function(error, d) {
    
    beachClosings = d;

    beachClosings.getByNumClosings = new function() {
        var closingsByBeach = {};
        beachClosings.forEach(function(d) {
            var thisBeachName = d.beachName;
            closingsByBeach[thisBeachName] = closingsByBeach[thisBeachName] + 1 || 1;
        });
 
        return sortClosings(closingsByBeach);
    }

    beachClosings.getByDate = new function() {
        var closingsByDate = {};
        beachClosings.forEach(function(d) {
            var thisDate = d.closedDate;
            closingsByDate[thisDate] = closingsByDate[thisDate] + 1 || 1;
        });

        return sortClosings(closingsByDate);
    }
        
    angular.element(document.getElementById('controllerId')).scope().showClosingsByBeach();
    angular.element(document.getElementById('controllerId')).scope().$apply();

});

function sortClosings(obj) {
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
    
    var retObj = {};
    for (var i=0; i < arr.length; i++) {
        retObj[arr[i].name] = arr[i].closings;
    }

    return retObj; // returns array
}
