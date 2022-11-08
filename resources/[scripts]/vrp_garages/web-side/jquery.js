var activeVehicle = null

window.addEventListener('message',function(event) {
    switch(event.data.action){
        case 'openNUI':
            activeVehicle = null;
            GarageUI.getVehicles();
            $("#garage").fadeIn();
            break;
        case 'closeNUI':
            $("#garage").fadeOut();
            break;
        case 'updateGarages':
            GarageUI.getVehicles();
            break;
    }
});

document.onkeyup = function(data){
    if (data.which == 27){
        $.post("http://vrp_garages/close");
    }
};

const GarageUI = {
    vehicles: {},
    thumbnailPrefix: "http://189.127.164.77/carros/",
    getVehicles: function() {
        $.get('http://vrp_garages/myVehicles', (data) => {
            let vehicles = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
            GarageUI.vehicles = vehicles;

            $(".list").html("");
            $.each(vehicles, function(index, item) {
                $(".list").append(`<div class="list-item" data-name="${item.name}" style="background-image: url(${GarageUI.thumbnailPrefix + item.name}.png)">
                    <div class="list-item-label">${item.name2}</div>
                </div>`);
            });

            GarageUI.getVehicle(vehicles[0].name);
            GarageUI.registerListeners();
        });
    },
    getVehicle: function(vehicleName) {
        let vehicle = GarageUI.vehicles.filter((v) => { return v.name == vehicleName; })[0];
        activeVehicle = vehicle;

        $(".list-item").removeClass("active");
        $(`.list-item[data-name='${vehicleName}']`).addClass("active");
        $(".vehicle-image").css("background-image", `url(${GarageUI.thumbnailPrefix + vehicleName}.png)`);
        $(".vehicle-name").html(vehicle.name2);

        $("#progress-bar-body .progress-bar-value").html(`${vehicle.body}%`);
        $("#progress-bar-body .progress-bar-filler").css("max-width", `${vehicle.body}%`);

        $("#progress-bar-engine .progress-bar-value").html(`${vehicle.engine}%`);
        $("#progress-bar-engine .progress-bar-filler").css("max-width", `${vehicle.engine}%`);

        $("#progress-bar-fuel .progress-bar-value").html(`${vehicle.fuel}%`);
        $("#progress-bar-fuel .progress-bar-filler").css("max-width", `${vehicle.fuel}%`);
    },
    spawnVehicle: function(vehicleName) {
        if(vehicleName == null) return false;

        $.post('http://vrp_garages/spawnVehicles', JSON.stringify({
            name: vehicleName
        }));
        activeVehicle = null;
    },
    pickVehicle: function() {
        $.post('http://vrp_garages/deleteVehicles');
    },
    registerListeners: function() {
        $(".list-item").on("click", function() {
            GarageUI.getVehicle($(this).attr("data-name"));
        });

        $(".get-vehicle").on("click", function() {
            if(activeVehicle == null) return false;
            GarageUI.spawnVehicle(activeVehicle.name);
        });

        $(".return-vehicle").on("click", function() {
            GarageUI.pickVehicle();
        });
    }
};