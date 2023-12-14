window.addEventListener('DOMContentLoaded',init,false);
var map = L.map('map').setView([51.505, -0.09], 3);
var tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
     maxZoom: 20,
     attribution: '<a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
     }).addTo(map);

function init(){

    var buttons = document.getElementsByTagName("button");
    for (var i = 0; i <  buttons.length; i++){
        buttons[i].addEventListener('click', setLocation, false);
       
    }  
    
};

function setLocation(){
console.log('Where did I click? ' + this.id)

    var location = this.id;
   /* var theData = 0*/
    var jsonData = fetch("https://raw.githubusercontent.com/DigitalMitford/stu2023_Journal/mapInterface/docs/subDocs/mapData2.geojson")
    .then(function (response) {
        return response.json();
    })
    .then(function (data) {
        for (let i in data.features){
            if (data.features[i].id == location){
                console.log(location);
                console.log('HI ' + data.features[i].properties.coordinates);
                  
                 // ebb: Update the map (the actual map variable) view without removing the map container  
                map.setView([data.features[i].properties.coordinates[0], data.features[i].properties.coordinates[1]], 15); //
                const tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
     maxZoom: 20,
     attribution: '<a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
     }).addTo(map);

            };
        }
     })
     .catch(function (err) {
        console.log(err);
    });

}
