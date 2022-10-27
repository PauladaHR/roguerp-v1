$(document).ready(function(){
	window.addEventListener('message',function(event){
		switch(event.data.action){
			case "openNUI":
				updateGarages();
				$("#actionmenu").fadeIn(100);
			break;

			case "closeNUI":
				$("#actionmenu").fadeOut(100);
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_garages/close");
		}
	};
});
/* --------------------------------------------------- */
const updateGarages = () => {
	$.post('http://vrp_garages/myVehicles',JSON.stringify({}),(data) => {
		const nameList = data.vehicles.sort((a,b) => (a.name2 > b.name2) ? 1: -1);
		$('#garagem').html(`
			<div id="buttons">
				<div class="spawn"><b>SPAWN</b><br>Veículo selecionado.</div>
				<div class="store"><b>GUARDAR</b><br>Veículo próximo.</div>
			</div>
			
		<div id="vehList">
			${nameList.map((item) => (`
				<div class="vehicle" data-name="${item.name}">
					<div id="vehicleName">${item.name2}</div>
					
							<div id="vehicleLegend"><b>Motor</b></div>
							<div id="vehicleBack">
								<div id="vehicleProgress" style="width: ${item.engine}%;"></div>
							</div>

							<div id="vehicleLegend"><b>Chassi</b></div>
							<div id="vehicleBack">
								<div id="vehicleProgress" style="width: ${item.body}%;"></div>
							</div>

							<div id="vehicleLegend"><b>Gasolina</b></div>
							<div id="vehicleBack">
								<div id="vehicleProgress" style="width: ${item.fuel}%;"></div>
							</div>
						</div>
			`)).join('')}
		</div>
		`);
	});
}
/* --------------------------------------------------- */
$(document).on('click','.vehicle',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	$('.vehicle').removeClass('active');
	if(!isActive) $el.addClass('active');
});
/* --------------------------------------------------- */
$(document).on('click','.spawn',debounce(function(){
	let $el = $('.vehicle.active').attr('data-name');
	if($el){
		$.post('http://vrp_garages/spawnVehicles',JSON.stringify({
			name: $el
		}));
	}
}));
/* --------------------------------------------------- */
$(document).on('click','.store',debounce(function(){
	$.post('http://vrp_garages/deleteVehicles');
}));
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,500)
		if (callNow) func.apply(context,args)
	}
}